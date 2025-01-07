# Dev shells for nixcats
{
  pkgs,
  defaultPackageName,
  defaultPackage,
  ...
}: @ args {

  # Default shell
  default = pkgs.mkShell {
    name = defaultPackageName;
    packages = [
      defaultPackage
    ];
    inputsFrom = [];
    shellHook = ''
    '';
  };
}
