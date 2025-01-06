# Mailcap settings for neomutt
{
  config,
  pkgs,
  ...
}: {
  # Generate mailcap file
  xdg.configFile = {
    "neomutt/mailcap" = {
      enable = true;
      text = ''
        text/html; ${pkgs.lynx}/bin/lynx -display_charset=utf-8 -dump %s; nametemplate=%s.html; copiousoutput
        text/*; more
      '';
    };
  };

  # Put the mailcap in config
  programs.neomutt.settings.mailcap_path = "${config.xdg.configHome}/neomutt/mailcap";

  # Include lynx in our packages
  home.packages = with pkgs; [
    lynx
  ];
}
