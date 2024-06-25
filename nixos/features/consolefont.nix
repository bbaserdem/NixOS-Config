# Module that sets consolefonts
{
  pkgs,
  lib,
  ...
}: {
  console = {
    earlySetup = true;
    font = "ter-powerline-v24b";
    packages = [
      pkgs.terminus_font
      pkgs.powerline-fonts
    ];
  };
}
