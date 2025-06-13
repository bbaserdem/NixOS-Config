# Setup browsers to be used
# TODO: Zotero connector as addon, and vdhcoapp as package
{pkgs, ...}: {
  # Enable stylix color theme
  stylix.targets.firefox = {
    enable = true;
    firefoxGnomeTheme.enable = true;
    profileNames = [
      "batuhan"
    ];
  };

  # Firefox settings
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      # See nixpkgs' firefox/wrapper.nix to check which options you can use
      nativeMessagingHosts = with pkgs; [
        browserpass
        bukubrow
        tridactyl-native
        gnome-browser-connector
        uget-integrator
        fx-cast-bridge
        vdhcoapp
        kdePackages.plasma-browser-integration
      ];
    };
    profiles.batuhan = {
      isDefault = true;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        augmented-steam
        automatic-dark
        batchcamp
        behind-the-overlay-revival
        betterttv
        browserpass
        # bukubrow : removed
        castkodi
        catppuccin-web-file-icons
        container-tab-groups
        container-tabs-sidebar
        containerise
        control-panel-for-twitter
        df-youtube
        don-t-fuck-with-paste
        duckduckgo-privacy-essentials
        enhanced-github
        flagfox
        gnome-shell-integration
        greasemonkey
        gruvbox-dark-theme
        h264ify
        hulu-ad-blocker
        languagetool
        leechblock-ng
        mullvad
        multi-account-containers
        plasma-integration
        protondb-for-steam
        sponsorblock
        steam-database
        ublock-origin
        video-downloadhelper
        zotero-connector
      ];
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
    };
  };
  home.packages = with pkgs; [
    vdhcoapp
  ];
}
