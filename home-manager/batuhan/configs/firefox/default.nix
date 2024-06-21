# Setup browsers to be used
# TODO: Zotero connector as addon, and vdhcoapp as package
{
  config,
  pkgs,
  ...
}: {
  # Firefox settings
  programs.firefox = {
    enable = true;
    profiles.batuhan = {
      isDefault = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        automatic-dark
        batchcamp
        behind-the-overlay-revival
        betterttv
        browserpass
        container-tabs-sidebar
        control-panel-for-twitter
        don-t-fuck-with-paste
        enhanced-github
        gnome-shell-integration
        greasemonkey
        mullvad
        multi-account-containers
        notion-web-clipper
        reddit-enhancement-suite
        sponsorblock
        ublock-origin
        video-downloadhelper
        zotero-connector
      ];
      search = {
        default = "Google";
        privateDefault = "Google";
        force = true;
        engines = {
          "Nix Packages" = {
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
                    value = pkgs.system;
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
          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            iconUpdateUrl = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@nw"];
          };
          "Arch Wiki" = {
            urls = [{template = "https://wiki.archlinux.org/index.php?search={searchTerms}";}];
            iconUpdateUrl = "https://nixos.wiki/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@aw"];
          };
          "Dotapedia" = {
            urls = [{template = "https://liquipedia.net/dota2game/{searchTerms}";}];
            iconUpdateUrl = "https://liquipedia.net/dota2game/extensions/SearchEngineOptimization/resources/images/favicon-32x32.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@d2"];
          };
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
    unstable.vdhcoapp
  ];
}
