{ self, lib, ... }:
let
  inherit (self.helpers) read;

  hostsRaw = read.toml ./hosts.toml;
  usersRaw = read.toml ./users.toml;
  featuresRaw = read.toml ./features.toml;

  removeDefaults = set: builtins.removeAttrs set [ "defaults" ];

  hosts = removeDefaults hostsRaw;
  users = removeDefaults usersRaw;

  # Schema validation over the raw TOML: shape, closed-domain enums, and
  # cross-table referential integrity for fields consumed in multiple places.
  # Collects every violation and throws a single aggregated message. Fields
  # consumed in a single module, and conditional cross-field rules, live in the
  # owning module via `flake.dex.rules` instead; see modules/dex/validate.nix.
  validHostTypes = [
    "laptop"
    "desktop"
    "headless"
    "vm"
  ];
  validSwap = [
    "zram"
    "zswap"
    "none"
  ];
  validLogitech = [
    "solaar"
    "openlogi"
    "none"
  ];
  # `hardware.gpu` indexes `pkgs.nvtopPackages.${gpu}` (system/pkgs.nix) and is
  # also read by jellyfin and dex (multi-consumer), while `hardware.cpu` gates
  # microcode and is read by dex (multi-consumer); both default to "" (unset)
  # for hosts with no discrete device, so empty is allowed through (see
  # enumError). Single-consumer closed domains (kernel, shell) are colocated
  # with their module via `flake.dex.rules` instead.
  validGpu = [
    "amd"
    "nvidia"
    "intel"
  ];
  validCpu = [
    "amd"
    "intel"
  ];

  nixosModuleNames = builtins.attrNames self.modules.nixos;
  homeModuleNames = builtins.attrNames self.modules.homeManager;

  vmHostNames = lib.filterAttrs (_: h: (h.type or null) == "vm") hosts;

  # An unset enum is `null` (absent) or "" (explicit "none/unset"); both skip the
  # check so hosts that legitimately omit a field (e.g. gpu on headless) pass.
  enumError =
    {
      ctx,
      field,
      value,
      valid,
    }:
    lib.optional (value != null && value != "" && !(builtins.elem value valid)) (
      "${ctx}: ${field} must be one of [ ${lib.concatStringsSep ", " valid} ] (got \"${toString value}\")."
    );

  membershipErrors =
    {
      ctx,
      field,
      values,
      valid,
    }:
    map (v: "${ctx}: ${field} references unknown \"${v}\".") (
      builtins.filter (v: !(builtins.elem v valid)) values
    );

  hostErrors = lib.concatLists (
    lib.mapAttrsToList (
      name: host:
      let
        ctx = "host '${name}'";
        features = host.features or { };
        hardware = host.hardware or { };
      in
      (enumError {
        inherit ctx;
        field = "type";
        value = host.type or null;
        valid = validHostTypes;
      })
      ++ (enumError {
        inherit ctx;
        field = "hardware.gpu";
        value = hardware.gpu or null;
        valid = validGpu;
      })
      ++ (enumError {
        inherit ctx;
        field = "hardware.cpu";
        value = hardware.cpu or null;
        valid = validCpu;
      })
      ++ (enumError {
        inherit ctx;
        field = "features.swap";
        value = features.swap or null;
        valid = validSwap;
      })
      ++ (enumError {
        inherit ctx;
        field = "features.logitech";
        value = features.logitech or null;
        valid = validLogitech;
      })
      ++ (membershipErrors {
        inherit ctx;
        field = "modules";
        values = host.modules or [ ];
        valid = nixosModuleNames;
      })
      ++ (lib.concatLists (
        lib.mapAttrsToList (
          uname: u:
          membershipErrors {
            ctx = "host '${name}' user '${uname}'";
            field = "modules";
            values = u.modules or [ ];
            valid = homeModuleNames;
          }
        ) (host.users or { })
      ))
      ++ (
        let
          mv = features.microvm or { };
        in
        lib.optionals (mv.enable or false) (membershipErrors {
          inherit ctx;
          field = "features.microvm.vms";
          values = mv.vms or [ ];
          valid = builtins.attrNames vmHostNames;
        })
      )
    ) hosts
  );

  userErrors = lib.concatLists (
    lib.mapAttrsToList (
      name: user:
      membershipErrors {
        ctx = "user '${name}'";
        field = "modules";
        values = user.modules or [ ];
        valid = homeModuleNames;
      }
    ) users
  );

  allErrors = hostErrors ++ userErrors;

  validated =
    value:
    if allErrors == [ ] then
      value
    else
      throw ("config: invalid TOML schema:\n  - " + lib.concatStringsSep "\n  - " allErrors);
in
{
  flake.tomlConfigs = validated {
    defaults = {
      hardware = read.toml ./hardware.toml;
      features = featuresRaw;
      users = usersRaw.defaults;
      host = hostsRaw.defaults;
    };

    inherit hosts users;
  };
}
