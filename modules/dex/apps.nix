{ self, lib, ... }:
let
  # Private /24 for the service containers. Each app gets two addresses from a
  # deterministic index (host side .<2n>, guest side .<2n+1>), mirroring how
  # modules/features/microvm.nix assigns VM IPs by index. IP
  # stability across edits does not matter: the host reaches a container by its
  # forwarded ports on 127.0.0.1, not by a fixed guest address.
  subnet = "10.231.7";

  # An app spec is a free attrset `{ module; ports ? []; gpu ? false; state ?
  # {}; mounts ? {}; guest ? {}; host ? (_: {}); }`.
  # `flake.dex` is an open (freeform) attrset, so no option is declared for it
  # — it is read directly from `self.dex.apps`, the way `helpers`/`getHost` are.
  rawApps = self.dex.apps or { };
  # Fill optional keys so the generator can read them unconditionally.
  apps = builtins.mapAttrs (_: spec: {
    ports = [ ];
    gpu = false;
    state = { };
    mounts = { };
    # Media/host mounts are read-only by default. Set false for a service that
    # must write back next to the media (e.g. silo's .nfo sidecars).
    mountsReadOnly = true;
    guest = { };
    host = _: { };
    # When true, open the app's forwarded ports on the host firewall so other
    # LAN machines can reach the service via the host's address. Default off,
    # so host-local services (adguard, ollama) are not exposed.
    external = false;
  } // spec) rawApps;
  appNames = lib.naturalSort (builtins.attrNames apps);

  addr = index: offset: "${subnet}.${toString (index * 2 + offset)}";

  # GPU passthrough, solved once. DRI covers AMD/Intel VAAPI and Vulkan; the
  # driver userspace lives behind /run/opengl-driver on the host and must be
  # visible to the guest.
  #
  # The /dev/nvidia* char nodes must be *bind-mounted*, not merely allowed:
  # allowedDevices only sets the cgroup device policy (permission to use a node
  # if present), while nspawn populates the guest /dev with a fixed default set
  # and never mirrors the nvidia nodes. Without the bind, CUDA's cuInit sees no
  # device (CUDA_ERROR_NO_DEVICE) even though nvidia-smi reads the GPU via
  # /dev/dri + the driver libs. uvm/uvm-tools are what cuInit needs. These are
  # NVIDIA-only paths, so bind them only on NVIDIA hosts — a bind of a missing
  # path fails the container on AMD/Intel.
  nvidiaNodes = [
    "/dev/nvidia0"
    "/dev/nvidiactl"
    "/dev/nvidia-uvm"
    "/dev/nvidia-uvm-tools"
    "/dev/nvidia-modeset"
  ];
  gpuBindMounts =
    hardware:
    {
      "/dev/dri".isReadOnly = false;
      "/run/opengl-driver" = { };
    }
    // lib.optionalAttrs hardware.hasNvidia (
      lib.genAttrs nvidiaNodes (_: { isReadOnly = false; })
    );
  gpuAllowedDevices =
    hardware:
    [
      { node = "/dev/dri/renderD128"; modifier = "rw"; }
      { node = "/dev/dri/card0"; modifier = "rw"; }
    ]
    ++ lib.optionals hardware.hasNvidia (map (node: { inherit node; modifier = "rw"; }) nvidiaNodes);

  # A spec's `ports` is either a literal list or a function of the host's
  # `features` (so a forwarded port can track e.g. `features.colibri.port`).
  resolvePorts = spec: features: if builtins.isFunction spec.ports then spec.ports features else spec.ports;

  # A port's `proto` ("tcp" | "udp" | "both", default tcp) expanded to the
  # concrete protocols to emit a rule for. Shared so the forward and DNAT rule
  # builders cannot drift (a mismatch would leave a DNAT add without a stop).
  protosOf = p: if (p.proto or "tcp") == "both" then [ "tcp" "udp" ] else [ (p.proto or "tcp") ];

  # `mounts`/`state` may each be a literal `{ host = guest; }` map or a function
  # of the host `ctx` (so e.g. media mounts can be derived from
  # `ctx.hardware.mounts`, the host's source of truth, instead of hardcoded).
  resolveAttrMap = m: ctx: if builtins.isFunction m then m ctx else m;

  mkForwardPorts =
    ports:
    lib.concatMap (
      p:
      map (protocol: {
        hostPort = p.host;
        containerPort = p.guest or p.host;
        inherit protocol;
      }) (protosOf p)
    ) ports;

  # systemd-nspawn's `--port=` forwarding (what `containers.forwardPorts`
  # installs) only DNATs traffic arriving on non-loopback interfaces, so the
  # host itself cannot reach a forwarded port via `127.0.0.1:<hostPort>`. Add an
  # OUTPUT-chain DNAT so host-local clients (e.g. a jellyfin/silo check) hit the
  # container. The container subnet is already masqueraded/routable from the
  # host, so redirecting to the guest address works.
  loopbackDnatRules =
    guestAddress: ports:
    lib.concatMapStrings (
      p:
      let
        guestPort = p.guest or p.host;
      in
      lib.concatMapStrings (
        proto:
        let
          rule = "-d 127.0.0.1 -p ${proto} --dport ${toString p.host} -j DNAT --to-destination ${guestAddress}:${toString guestPort}";
        in
        # Check-then-add so the rule is idempotent on every firewall reload,
        # regardless of whether the matching stop rule found its target. Without
        # this, a stop rule that fails to match (e.g. after an app is renumbered
        # and the old guest IP no longer matches) leaves a stale DNAT rule.
        ''
          iptables -w -t nat -C OUTPUT ${rule} 2>/dev/null || iptables -w -t nat -A OUTPUT ${rule}
        ''
      ) (protosOf p)
    ) ports;

  loopbackDnatStopRules =
    guestAddress: ports:
    lib.concatMapStrings (
      p:
      let
        guestPort = p.guest or p.host;
      in
      lib.concatMapStrings (proto: ''
        iptables -w -t nat -D OUTPUT -d 127.0.0.1 -p ${proto} --dport ${toString p.host} -j DNAT --to-destination ${guestAddress}:${toString guestPort} 2>/dev/null || true
      '') (protosOf p)
    ) ports;

  # Host ports to open for `external` apps, for one protocol. A port is opened
  # when its spec proto is that proto or "both".
  forwardedPortsByProto =
    ports: proto:
    lib.concatMap (p: lib.optional ((p.proto or "tcp") == proto || (p.proto or "tcp") == "both") p.host) ports;

  mkBindMounts =
    spec: ctx:
    (lib.optionalAttrs spec.gpu (gpuBindMounts ctx.hardware))
    // (builtins.mapAttrs (_: guest: {
      hostPath = guest;
      isReadOnly = false;
    }) (lib.mapAttrs' (host: guest: lib.nameValuePair guest host) (resolveAttrMap spec.state ctx)))
    // (builtins.mapAttrs (_: guest: {
      hostPath = guest;
      isReadOnly = spec.mountsReadOnly;
    }) (lib.mapAttrs' (host: guest: lib.nameValuePair guest host) (resolveAttrMap spec.mounts ctx)));

  # Build the container NixOS module for one app. `ctx` is the host's module
  # args (features/hardware/pkgs/secrets/lib), forwarded into the guest via
  # _module.args because a NixOS container evaluates its config as a separate
  # system and does NOT inherit the host's specialArgs.
  mkContainerModule =
    index: name: spec: ctx:
    let
      hostAddress = addr index 0;
      guestAddress = addr index 1;
    in
    {
      # `spec.host` is a module fragment (host-side glue, e.g. a resolver
      # pointing at this container). It is `imports`ed, not `//`-merged: both it
      # and the body below define `networking.*`, and `//` is a shallow merge —
      # the host fragment's `networking` would replace the body's `networking`
      # wholesale, silently dropping `networking.nat` (the container's
      # masquerade), which breaks the container's outbound networking.
      imports = [ (spec.host { inherit guestAddress hostAddress; }) ];

      networking.nat = {
        enable = true;
        internalInterfaces = [ "ve-+" ];
        # Masquerade the container subnet out whatever interface routes to the
        # internet; without this the container's upstream DNS (and all outbound
        # traffic) is never SNATed and times out. No fixed external interface is
        # named so this works on any host (laptop wifi, desktop ethernet).
        internalIPs = [ "${subnet}.0/24" ];
      };

      # Give the guest the host's DNS: open an extra resolved stub listener on
      # this container's host-side veth IP (not 0.0.0.0 — that would clash with
      # resolved's main 127.0.0.53 listener and silently fail to bind). The guest
      # points `networking.nameservers` at this hostAddress; resolved answers
      # from the host's own view (adguard when present, else FallbackDNS). Open
      # port 53 on the veth so the query reaches it (fenced off the LAN).
      services.resolved.settings.Resolve.DNSStubListenerExtra = [ hostAddress ];
      networking.firewall.interfaces."ve-${name}" = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };

      networking.firewall.extraCommands = loopbackDnatRules guestAddress (
        resolvePorts spec ctx.features
      );
      networking.firewall.extraStopCommands = loopbackDnatStopRules guestAddress (
        resolvePorts spec ctx.features
      );

      # Opt-in LAN exposure: nspawn's --port= already DNATs traffic arriving on
      # a routed interface, but the host INPUT chain drops it unless the port is
      # opened here.
      networking.firewall.allowedTCPPorts = lib.optionals spec.external (
        forwardedPortsByProto (resolvePorts spec ctx.features) "tcp"
      );
      networking.firewall.allowedUDPPorts = lib.optionals spec.external (
        forwardedPortsByProto (resolvePorts spec ctx.features) "udp"
      );

      containers.${name} = {
        autoStart = true;
        privateNetwork = true;
        inherit hostAddress;
        localAddress = guestAddress;

        forwardPorts = mkForwardPorts (resolvePorts spec ctx.features);
        bindMounts = mkBindMounts spec ctx;

        allowedDevices = lib.optionals spec.gpu (gpuAllowedDevices ctx.hardware);

        config = {
          # Likewise `imports`, not `//`: `spec.guest` may also set
          # `networking.*`, which `//` would shallow-merge over the fields set
          # here.
          imports = [ spec.module spec.guest ];

          # Forward the host module args the service modules expect.
          _module.args = {
            inherit (ctx)
              features
              hardware
              secrets
              host
              ;
          };

          nixpkgs.pkgs = ctx.pkgs;

          # The guest owns its own network namespace, so it can't use the host's
          # resolved stub (127.0.0.53, loopback-only). Dial the host instead, at
          # this container's host-side veth IP, where the host opens an extra
          # resolved stub listener (see the host block below). The host resolver
          # forwards to whatever the host uses — adguard when present, else its
          # FallbackDNS. `mkDefault` lets a spec.guest override.
          networking.useHostResolvConf = lib.mkForce false;
          networking.nameservers = lib.mkDefault [ hostAddress ];
          networking.firewall.enable = lib.mkForce false;

          # The container NAT is IPv4-only, so there is no IPv6 egress. Without
          # this, resolvers hand apps AAAA records (e.g. api.themoviedb.org is
          # IPv6-only from here) and they dial a dead IPv6 route and fail
          # silently. Disabling IPv6 leaves only the working IPv4 path.
          networking.enableIPv6 = lib.mkDefault false;

          system.stateVersion = ctx.hostStateVersion;
        };
      };
    };
in
{
  # Generate one container-wrapper `flake.modules.nixos.<name>` per registered
  # app, so each service module only declares its `flake.dex.apps.<name>` spec
  # (which carries `module = <its own -service body>`) — no extra per-module
  # wiring. Because the wrapper reuses the app's own name, the existing
  # `featureGuard "<name>"` in entrypoint.nix picks up this containerized
  # version unchanged.
  #
  # Deriving the KEY set from the registry is safe as long as we force only the
  # registry's spine (`appNames` = `attrNames`), never a spec's `.module` — that
  # field references `self.modules.nixos.<name>-service`, and forcing it here
  # would loop back through this very `flake.modules.nixos` definition. The
  # wrapper only touches `.module` inside `imports`, evaluated lazily at host
  # build time, so the cycle never forms.
  flake.modules.nixos = builtins.listToAttrs (
    lib.imap0 (
      index: name:
      lib.nameValuePair name (
        { features, hardware, pkgs, secrets, host, config, ... }:
        mkContainerModule index name apps.${name} {
          inherit features hardware pkgs secrets host;
          hostStateVersion = config.system.stateVersion;
        }
      )
    ) appNames
  );

  # Validation: among the apps actually enabled on a host (their feature is
  # toggled on), no two forward the same host port. Disabled apps are ignored
  # so mutually-exclusive pairs (e.g. silo vs jellyfin on 8096) don't trip it.
  flake.dex.rules = [
    (
      { features, ... }:
      let
        enabled = builtins.filter (name: (features.${name}.enable or features.${name} or false) == true) appNames;
        allPorts = lib.concatMap (name: map (p: p.host) (resolvePorts apps.${name} features)) enabled;
        dups = lib.subtractLists (lib.unique allPorts) allPorts;
      in
      lib.optional (dups != [ ]) "dex.apps: enabled containers share forwarded host ports ${toString dups}."
    )
  ];
}
