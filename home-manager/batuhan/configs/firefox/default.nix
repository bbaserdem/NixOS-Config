# Setup browsers to be used
# TODO: Zotero connector as addon, and vdhcoapp as package
{pkgs, ...}: {
  # Firefox settings
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      # See nixpkgs' firefox/wrapper.nix to check which options you can use
      nativeMessagingHosts = [
        pkgs.browserpass
        pkgs.bukubrow
        pkgs.tridactyl-native
        pkgs.gnome-browser-connector
        pkgs.uget-integrator
        pkgs.fx-cast-bridge
      ];
    };
    profiles.batuhan = {
      isDefault = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        augmented-steam
        automatic-dark
        batchcamp
        behind-the-overlay-revival
        betterttv
        browserpass
        bukubrow
        castkodi
        catppuccin-gh-file-explorer
        container-tab-groups
        container-tabs-sidebar
        containerise
        control-panel-for-twitter
        df-youtube
        don-t-fuck-with-paste
        duckduckgo-for-firefox
        enhanced-github
        firenvim
        flagfox
        gnome-shell-integration
        greasemonkey
        gruvbox-dark-theme
        h264ify
        hulu-ad-blocker-firefox
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
        default = "Google";
        privateDefault = "Google";
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
          "Google".metaData.alias = "@g";
        };
      };
      #containers = {
      #  personal      = { name = "Personal";    id = 0; icon = "tree";        color = "blue";     };
      #  work          = { name = "Work";        id = 1; icon = "briefcase";   color = "turquoise";};
      #  banking       = { name = "Finance";     id = 2; icon = "dollar";      color = "green";    };
      #  shopping      = { name = "Shopping";    id = 3; icon = "cart";        color = "yellow";   };
      #  porn          = { name = "Explicit";    id = 4; icon = "pet";         color = "orange";   };
      #  media         = { name = "Media";       id = 5; icon = "fruit";       color = "red";      };
      #  productivity  = { name = "Organization";id = 6; icon = "fence";       color = "pink";     };
      #  programming   = { name = "Programming"; id = 7; icon = "fingerprint"; color = "purple";   };
      #};
    };
  };
  home.packages = with pkgs; [
    vdhcoapp
  ];
}
