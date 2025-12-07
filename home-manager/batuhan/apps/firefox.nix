# Setup browsers to be used
{
  pkgs,
  lib,
  arch,
  ...
}: let
  nmhOverride = {
    nativeMessagingHosts = with pkgs;
      [
        browserpass
        bukubrow
        tridactyl-native
        keepassxc
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        vdhcoapp
        fx-cast-bridge
        uget-integrator
        gnome-browser-connector
        kdePackages.plasma-browser-integration
      ];
  };
in (lib.mkMerge [
  (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    xdg.mimeApps.defaultApplications = {
      "text/html" = ["firefox.desktop"];
      "text/xml" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };
  })
  {
    # Enable stylix color theme
    stylix.targets.firefox = {
      enable = true;
      colorTheme.enable = true;
      firefoxGnomeTheme.enable = true;
      profileNames = [
        "batuhan"
      ];
    };

    # Firefox settings
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override nmhOverride;
      profiles.batuhan = {
        isDefault = true;
        extensions = {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            augmented-steam
            automatic-dark
            batchcamp
            behind-the-overlay-revival
            betterttv
            castkodi
            catppuccin-web-file-icons
            containerise
            control-panel-for-twitter
            don-t-fuck-with-paste
            duckduckgo-privacy-essentials
            enhanced-github
            flagfox
            gnome-shell-integration
            greasemonkey
            gruvbox-dark-theme
            h264ify
            hulu-ad-blocker
            keepassxc-browser
            languagetool
            mullvad
            multi-account-containers
            open-url-in-container
            plasma-integration
            protondb-for-steam
            sponsorblock
            steam-database
            ublock-origin
            user-agent-string-switcher
            video-downloadhelper
            zotero-connector
          ];
        };
        search = {
          default = "google";
          privateDefault = "google";
          force = true;
          engines = {
            "Nix Packages ${pkgs.lib.trivial.codeName}" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = pkgs.lib.trivial.release;
                    }
                    {
                      name = "sort";
                      value = "relevance";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };
            "NixOS Options ${pkgs.lib.trivial.codeName}" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = pkgs.lib.trivial.release;
                    }
                    {
                      name = "sort";
                      value = "relevance";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@no"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              iconUpdateUrl = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@nw"];
            };
            "Home Manager Options" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@hm"];
            };
            "Arch Wiki" = {
              urls = [{template = "https://wiki.archlinux.org/index.php?search={searchTerms}";}];
              iconUpdateUrl = "https://wiki.archlinux.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@aw"];
            };
            "Gentoo Wiki" = {
              urls = [{template = "https://wiki.gentoo.org/?search={searchTerms}";}];
              iconUpdateUrl = "https://wiki.gentoo.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@ge"];
            };
            "Wikipedia" = {
              urls = [
                {
                  template = "https://en.wikipedia.org/w/index.php";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateUrl = "https://en.wikipedia.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@wi"];
            };
            "Dotapedia" = {
              urls = [{template = "https://liquipedia.net/dota2/index.php?search={searchTerms}";}];
              iconUpdateUrl = "https://www.dota2.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@d2"];
            };
            "google".metaData.alias = "@g";
          };
        };
        containers = {
          work = {
            name = "Work";
            id = 1;
            icon = "briefcase";
            color = "blue";
          };
          banking = {
            name = "Banking";
            id = 2;
            icon = "dollar";
            color = "green";
          };
          porn = {
            name = "Explicit";
            id = 3;
            icon = "pet";
            color = "red";
          };
        };

        # about:config
        settings = {
          # Set startup page; with different containers
          "network.protocol-handler.external.ext+container" = true;
          "browser.startup.homepage" = pkgs.lib.strings.concatStringsSep "|" [
            "http://127.0.0.1:8384/"
            "https://mail.google.com/mail/u/0/#inbox"
            "ext+container:name=Work&url=https://mail.google.com/mail/u/0/#inbox"
          ];
          "services.sync.prefs.sync-seen.browser.startup.homepage" = false;

          # Disable first-run things
          "browser.disableResetPrompt" = true;
          "browser.download.panel.shown" = true;
          "browser.feeds.showFirstRunUI" = false;
          "browser.messaging-system.whatsNewPanel.enabled" = false;
          "browser.rights.3.shown" = true;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.uitour.enabled" = false;
          "startup.homepage_override_url" = "";
          "trailhead.firstrun.didSeeAboutWelcome" = true;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.bookmarks.addedImportButton" = true;

          # Don't ask for download dir
          "browser.download.useDownloadDir" = true;

          # Disable telemetry

          # Disable some telemetry
          "app.shield.optoutstudies.enabled" = false;
          "services.sync.prefs.app.shield.optoutstudies.enabled" = false;
          "browser.discovery.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.sessions.current.clean" = true;
          "devtools.onboarding.telemetry.logged" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.prompted" = 2;
          "toolkit.telemetry.rejected" = true;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.unifiedIsOptIn" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          # Options not to sync
          "services.sync.prefs.sync-seen.browser.firefox-view.feature-tour" = false;

          # Layout# Layout
          "browser.uiCustomization.state" = builtins.toJSON {
            currentVersion = 24;
            newElementCount = 13;
            dirtyAreaCache = [
              "nav-bar"
              "vertical-tabs"
              "PersonalToolbar"
              "unified-extensions-area"
              "toolbar-menubar"
              "TabsToolbar"
              "widget-overflow-fixed-list"
            ];
            placements = {
              nav-bar = [
                "firefox-view-button"
                "back-button"
                "forward-button"
                "stop-reload-button"
                "urlbar-container"
                "_testpilot-containers-browser-action"
                "bookmarks-menu-button"
                "history-panelmenu"
                "downloads-button"
                "sidebar_button"
                "unified-extensions-button"
              ];
              PersonalToolbar = [
                "search-container"
                "zoom-controls"
                # Dunno
                "_8a3715dc-7333-46d9-a133-a378fa5625bd_-browser-action"
                # Ublock origin
                "ublock0_raymondhill_net-browser-action"
                # Remove overlay
                "_c0e1baea-b4cb-4b62-97f0-278392ff8c37_-browser-action"
                # Zotero connector
                "zotero_chnm_gmu_edu-browser-action"
                # Video DownloadHelper
                "_b9db16a4-6edc-47ec-a1f4-b86292ed211d_-browser-action"
                # Kodi cast
                "castkodi_regseb_github_io-browser-action"
                # Geo control
                "_ad6b7cbf-38b5-4399-8f16-d56855de1f68_-browser-action"
                # Mullvad vpn
                "_d19a89b9-76c1-4a61-bcd4-49e8de916403_-browser-action"
                # Greasemonkey
                "_e4a8a97b-f2ed-450b-b12d-ee082ba24781_-browser-action"
                # Containarize
                "containerise_kinte_sh-browser-action"
                # Bookmarks
                "personal-bookmarks"
              ];
              TabsToolbar = [
                "tabbrowser-tabs"
                "new-tab-button"
                "alltabs-button"
                "tab-array_menhera_org-browser-action"
              ];
              toolbar-menubar = [
                "menubar-items"
              ];
              unified-extensions-area = [
                "_3c9b993f-29b9-44c2-a913-def7b93a70b1_-browser-action"
                "_44df5123-f715-9146-bfaa-c6e8d4461d44_-browser-action"
                "_d44fa1f9-1400-401d-a79e-650d466ec6d6_-browser-action"
                "containertabssidebar_maciekmm_net-browser-action"
                "dontfuckwithpaste_raim_ist-browser-action"
                "_5cce4ab5-3d47-41b9-af5e-8203eea05245_-browser-action"
                "_72bd91c9-3dc5-40a8-9b10-dec633c0873f_-browser-action"
                "uget-integration_slgobinath-browser-action"
                "user-agent-switcher_ninetailed_ninja-browser-action"
                "chrome-gnome-shell_gnome_org-browser-action"
                "_4b547b2c-e114-4344-9b70-09b2fe0785f3_-browser-action"
                "plasma-browser-integration_kde_org-browser-action"
                "_bbb880ce-43c9-47ae-b746-c3e0096c5b76_-browser-action"
                "dfyoutube_example_com-browser-action"
                "jid1-tsgsxbhncspbwq_jetpack-browser-action"
                "_a1541a5e-68f8-480d-8f10-784f93079060_-browser-action"
                "_25d049c4-af50-480c-bea8-09fc8bcc5323_-browser-action"
                "firefox-extension_steamdb_info-browser-action"
                "languagetool-webextension_languagetool_org-browser-action"
                "jid1-zadieub7xozojw_jetpack-browser-action"
                "_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action"
              ];
              widget-overflow-fixed-list = [];
            };
            seen = [
              "save-to-pocket-button"
              "developer-button"
              "_3c9b993f-29b9-44c2-a913-def7b93a70b1_-browser-action"
              "_44df5123-f715-9146-bfaa-c6e8d4461d44_-browser-action"
              "_d44fa1f9-1400-401d-a79e-650d466ec6d6_-browser-action"
              "_c0e1baea-b4cb-4b62-97f0-278392ff8c37_-browser-action"
              "browserpass_maximbaz_com-browser-action"
              "containertabssidebar_maciekmm_net-browser-action"
              "dontfuckwithpaste_raim_ist-browser-action"
              "_5cce4ab5-3d47-41b9-af5e-8203eea05245_-browser-action"
              "_72bd91c9-3dc5-40a8-9b10-dec633c0873f_-browser-action"
              "_testpilot-containers-browser-action"
              "uget-integration_slgobinath-browser-action"
              "user-agent-switcher_ninetailed_ninja-browser-action"
              "chrome-gnome-shell_gnome_org-browser-action"
              "_e4a8a97b-f2ed-450b-b12d-ee082ba24781_-browser-action"
              "_d19a89b9-76c1-4a61-bcd4-49e8de916403_-browser-action"
              "_4b547b2c-e114-4344-9b70-09b2fe0785f3_-browser-action"
              "sponsorblocker_ajay_app-browser-action"
              "ublock0_raymondhill_net-browser-action"
              "_b9db16a4-6edc-47ec-a1f4-b86292ed211d_-browser-action"
              "zotero_chnm_gmu_edu-browser-action"
              "_ad6b7cbf-38b5-4399-8f16-d56855de1f68_-browser-action"
              "plasma-browser-integration_kde_org-browser-action"
              "bukubrow_samhh_com-browser-action"
              "castkodi_regseb_github_io-browser-action"
              "containerise_kinte_sh-browser-action"
              "tab-array_menhera_org-browser-action"
              "_bbb880ce-43c9-47ae-b746-c3e0096c5b76_-browser-action"
              "dfyoutube_example_com-browser-action"
              "jid1-tsgsxbhncspbwq_jetpack-browser-action"
              "_a1541a5e-68f8-480d-8f10-784f93079060_-browser-action"
              "_25d049c4-af50-480c-bea8-09fc8bcc5323_-browser-action"
              "firefox-extension_steamdb_info-browser-action"
              "_8a3715dc-7333-46d9-a133-a378fa5625bd_-browser-action"
              "languagetool-webextension_languagetool_org-browser-action"
              "jid1-zadieub7xozojw_jetpack-browser-action"
              "_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action"
              "screenshot-button"
            ];
          };
        };
      };
    };

    home.packages = (
      if lib.hasSuffix "-darwin" arch
      then []
      else if lib.hasSuffix "-linux" arch
      then [
        # Needed connection for VideoDownloadHelper
        pkgs.vdhcoapp
        # Also have chromium available for compatibility
        # ungoogled-chromium
      ]
      else []
    );
  }
])
