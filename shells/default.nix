# shell.nix
{
  pkgs,
  inputs,
  system,
  ...
}: {
  # Main dev shell
  default = pkgs.mkShell {
    packages = with pkgs; [
      # Default stuff needed
      nix
      home-manager
      git
      # Encryption
      sops
      ssh-to-age
      gnupg
      age
      # Plugin installing
      pnpm
      nodejs-slim
      uv
      # Useful packages to have
      dconf2nix
      update-nix-fetchgit
      nix-prefetch-github
      nixos-anywhere
    ];
    env = {
      NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations pipe-operators";
    };
    # Shell hooks
    shellHook = ''
      # Setup node
      export PATH="./node_modules/.bin:$PATH"
    '';
  };

  # Extra dev shells
  ags = import ./ags.nix {inherit pkgs inputs system;};
  python = import ./python.nix {inherit pkgs inputs system;};
}
