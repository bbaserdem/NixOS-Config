# shell.nix
{
  pkgs,
  inputs,
  system,
  ...
}: {
  # Main dev shell
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations pipe-operators";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git

      sops
      ssh-to-age
      gnupg
      age
      neovim
    ];
  };

  # Extra dev shells
  ags = import ./ags.nix {inherit pkgs inputs system;};
}
