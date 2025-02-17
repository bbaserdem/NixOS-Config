# shell.nix
{
  pkgs,
  inputs,
  system,
  ...
}:
pkgs.mkShell {
  buildInputs = [
    # includes astal3 astal4 astal-io by default
    (inputs.ags.packages.${system}.default.override {
      extraPackages = [
        # cherry pick packages
      ];
    })
  ];
}
