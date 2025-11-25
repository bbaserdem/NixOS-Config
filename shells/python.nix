# shell.nix
{
  pkgs,
  inputs,
  system,
  ...
}:
pkgs.mkShell {
  packages = with pkgs; [
    # Default stuff
    nodejs-slim
    pnpm
    git
    # Python tooling
    uv
  ];
  shellHook = ''
    # Setup node
    export PATH="./node_modules/.bin:$PATH"
  '';
}
