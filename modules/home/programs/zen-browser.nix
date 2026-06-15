{ _, ... }:
{
  flake-file.inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  flake.modules.homeManager.zen-browser =
    {
      inputs,
      config,
      secrets,
      ...
    }:
    {
      imports = [
        inputs.zen-browser.homeModules.default
      ];

      xdg.mimeApps =
        let
          associations = builtins.listToAttrs (
            map
              (name: {
                inherit name;
                value =
                  let
                    zen-browser = config.programs.zen-browser.package;
                  in
                  zen-browser.meta.desktopFileName;
              })
              [
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
              ]
          );
        in
        {
          associations.added = associations;
          defaultApplications = associations;
        };

      programs.zen-browser = {
        enable = true;
        policies =
          let
            mkLockedAttrs = builtins.mapAttrs (
              _: value: {
                Value = value;
                Status = "locked";
              }
            );

            mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

            mkExtensionEntry =
              {
                id,
                pinned ? false,
              }:
              let
                base = {
                  install_url = mkPluginUrl id;
                  installation_mode = "force_installed";
                };
              in
              if pinned then base // { default_area = "navbar"; } else base;

            mkExtensionSettings = builtins.mapAttrs (
              _: entry: if builtins.isAttrs entry then entry else mkExtensionEntry { id = entry; }
            );
          in
          {
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
              "browser.download.panel.shown" = true;
              "browser.download.useDownloadDir" = false;

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
              "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = true;
              "browser.tabs.insertAfterCurrent " = true;
            };
          };

        profiles.default = {
          settings = {
            "zen.workspaces.continue-where-left-off" = true;
            "zen.workspaces.natural-scroll" = true;
            "zen.welcome-screen.seen" = true;
            "zen.urlbar.behavior" = "float";
            "zen.theme.accent-color" = "#d4bbff";
            "zen.tabs.newtab-button-top" = false;
            "zen.tabs.show-newtab-vertical" = false;
            "zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = true;
            "zen.workspaces.separate-essentials" = false;
            "zen.workspaces.open-new-tab-if-last-unpinned-tab-is-closed" = true;
            "zen.folders.owned-tabs-in-folder" = true;
          };

          mods = [
            "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
            "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
            "79dde383-4fe7-404a-a8e6-9be440022542" # Tidy Popup
          ];

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
                texture = 0.0;
              };
            };
          };

          pinsForce = true;
          pins = secrets.zen-browser_pins;
          keyboardShortcuts = [
            {
              id = "zen-compact-mode-toggle";
              key = "s";
              modifiers = {
                control = false;
                alt = true;
              };
            }
            # Disable the quit shortcut to prevent accidental closes
            {
              id = "key_quitApplication";
              disabled = true;
            }
          ];
        };
      };
    };
}
