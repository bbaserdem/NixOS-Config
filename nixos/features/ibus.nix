# nixos/features/ibus.nix
# IBus
{pkgs, ...}: {
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      uniemoji
      mozc-ut
    ];
  };
}
