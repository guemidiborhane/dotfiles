{
  inputs,
  pkgs,
  config,
  ...
}: {

  imports = [
    inputs.zen-browser.homeModules.default
  ];

  xdg.mimeApps = let
    associations = builtins.listToAttrs (map (name: {
        inherit name;
        value = let
          zen-browser = config.programs.zen-browser.package;
        in
          zen-browser.meta.desktopFileName;
      }) [
        "application/x-extension-shtml"
        "application/x-extension-xhtml"
        "application/x-extension-html"
        "application/x-extension-xht"
        "application/x-extension-htm"
        "x-scheme-handler/unknown"
        "x-scheme-handler/mailto"
        "x-scheme-handler/chrome"
        "x-scheme-handler/about"
        "x-scheme-handler/https"
        "x-scheme-handler/http"
        "application/xhtml+xml"
        "application/json"
        "text/plain"
        "text/html"
      ]);
  in {
    associations.added = associations;
    defaultApplications = associations;
  };

  programs.zen-browser = {
    enable = true;
    policies = let
      mkLockedAttrs = builtins.mapAttrs (_: value: {
        Value = value;
        Status = "locked";
      });

      mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

      mkExtensionEntry = {
        id,
        pinned ? false,
      }: let
        base = {
          install_url = mkPluginUrl id;
          installation_mode = "force_installed";
        };
      in
        if pinned
        then base // {default_area = "navbar";}
        else base;

      mkExtensionSettings = builtins.mapAttrs (_: entry:
        if builtins.isAttrs entry
        then entry
        else mkExtensionEntry {id = entry;});
    in {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      SanitizeOnShutdown = {
        FormData = true;
        Cache = true;
      };
      ExtensionSettings = mkExtensionSettings {
        "uBlock0@raymondhill.net" = {
          id = "ublock-origin";
          pinned = true;
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          id = "bitwarden-password-manager";
          pinned = true;
        };
        "firefox@ghostery.com" = "ghostery";
        "jid1-BoFifL9Vbdl2zQ@jetpack" = "decentraleyes";
        "jid1-ZAdIEUB7XOzOJw@jetpack" = "duckduckgo-for-firefox";

        "languagetool-webextension@languagetool.org" = "languagetool";
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium-ff";
        "addon@darkreader.org" = "darkreader";

        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
        "sponsorBlocker@ajay.app" = "sponsorblock";
        "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" = "video-downloadhelper";

        "devtools@marvinh.dev" = "preact-devtools";
        "jsonview@brh.numbera.com" = "jsonview";
        "{24ee4c09-47ea-497b-9c22-4058a6e55aa5}" = "vue-js-devtools-v6-legacy";
        "@react-devtools" = "react-devtools";
      };

      Preferences = mkLockedAttrs {
        "browser.aboutConfig.showWarning" = false;
        "browser.tabs.warnOnClose" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
        "browser.tabs.hoverPreview.enabled" = true;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.topsites.contile.enabled" = false;

        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.randomization.canvas.use_siphash" = true;
        "privacy.resistFingerprinting.randomization.daily_reset.enabled" = true;
        "privacy.resistFingerprinting.randomization.daily_reset.private.enabled" = true;
        "privacy.resistFingerprinting.block_mozAddonManager" = true;
        "privacy.spoof_english" = 1;

        "privacy.firstparty.isolate" = true;
        "network.cookie.cookieBehavior" = 5;
        "dom.battery.enabled" = false;

        "gfx.webrender.all" = true;
        "network.http.http3.enabled" = true;
        "network.socket.ip_addr_any.disabled" = true; # disallow bind to 0.0.0.0
      };
    };

    profiles.default = rec {
      settings = {
        "zen.workspaces.continue-where-left-off" = true;
        "zen.workspaces.natural-scroll" = true;
        "zen.welcome-screen.seen" = true;
        "zen.urlbar.behavior" = "float";
        "zen.theme.accent-color" = "#d4bbff";
      };

      spaces = {
        "Personal" = {
          id = "ad97a477-95a8-4504-9eef-0d27cf8ce6b4";
          icon = "🏠";
          theme = {
            type = "gradient";
            colors = [
              {
                red = 40;
                green = 42;
                blue = 54;
              }
            ];
            opacity = 1.0;
            texture = 0.5;
          };
        };
      };

      pinsForce = true;
      pins = let
        decode = encodedStr: let
          outFile = pkgs.runCommand "decode-base64" {} "echo '${encodedStr}' | base64 --decode > $out";
        in
          builtins.readFile outFile;
      in {
        "translate" = {
          id = "700370e7-7d89-48f3-be0d-20bf81c24959";
          url = decode "aHR0cHM6Ly90cmFuc2xhdGUuZ29vZ2xlLmNvbQ==";
          position = 101;
          isEssential = true;
        };
        "users" = {
          id = "0a81badb-b01b-4807-9680-9cebed731b06";
          url = decode "aHR0cHM6Ly9kZ3BjLmFpbmEuZHovdXNlcnM=";
          position = 102;
          isEssential = true;
        };
        "bird" = {
          id = "ec689f12-fdc2-49ce-b4dc-ca10966b495f";
          url = decode "aHR0cHM6Ly9iaXJkLm5ldHN5cy5keg==";
          position = 103;
          isEssential = true;
        };
        "daily-dev" = {
          id = "46978cc4-ecd3-459c-a490-7c3253a1983a";
          url = "https://app.daily.dev";
          position = 104;
          isEssential = true;
        };
        "subscriptions" = {
          id = "6fce947d-238e-492c-81f8-9c7e53c7e785";
          url = "https://youtube.com/feed/subscriptions";
          position = 105;
          isEssential = true;
        };
        "jellyfin" = {
          id = "a8cf8e7e-98e8-44f1-98ec-9c3e41f26ebe";
          url = decode "aHR0cHM6Ly8xMC4wLjAuMTA6ODA5Ng==";
          position = 106;
          isEssential = true;
        };
      };
    };
  };
}
