# Shell configurations
{
  pkgs,
  inputs,
  system,
  uvBoilerplate,
  ...
}: let
  # Helper to create shells
  mkShell = config:
    pkgs.mkShell {
      packages = config.packages;
      env = config.env;
      shellHook = config.shellHook;
    };

  # Common configuration used by all shells
  commonShell = import ./common.nix {inherit pkgs;};
  # Individual shell configurations
  pythonShell = import ./python.nix {inherit pkgs commonShell uvBoilerplate;};

  # Default shell with all development tools
  defaultShell = {
    packages = pkgs.lib.unique (
      commonShell.packages
      ++ uvBoilerplate.uvShellSet.packages
    );

    env = commonShell.env // uvBoilerplate.uvShellSet.env;

    shellHook = ''
      ${commonShell.shellHook}
      ${uvBoilerplate.uvShellSet.shellHook}
    '';
  };
in {
  # Export all shell environments
  default = mkShell defaultShell;
  minimal = mkShell commonShell;
  python = mkShell pythonShell;
}
