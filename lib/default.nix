# My library of stuff to cut out boilerplate
# Mostly from https://github.com/vimjoyer/nixconf/tree/main/myLib
{
  inputs,
  outputs,
  ...
}: rec {
  # ================================================================ #
  # ============================ My Lib ============================ #
  # ================================================================ #

  rootDir = "${inputs.self}";

  # My make-if functions
  mkIfElse = p: yes: no:
    inputs.nixpkgs.lib.mkMerge [
      (inputs.nixpkgs.lib.mkIf p yes)
      (inputs.nixpkgs.lib.mkIf (!p) no)
    ];
  mkUnless = p: no: inputs.nixpkgs.lib.mkIf (!p);

  # ========================== Buildables ========================== #

  # Generate NixOS configs for hosts
  mkConfiguredHost = configuredHosts:
    builtins.listToAttrs (
      map ({
        host,
        arch,
      }: {
        name = "${host}";
        value = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs host arch;};
          modules = [
            ../nixos
            ../nixos/hosts/${host}
          ];
        };
      })
      configuredHosts
    );

  # Generate standalone home-manager configs
  mkConfiguredUser = user: configuredHosts:
    builtins.listToAttrs (
      map ({
        host,
        arch,
      }: {
        name = "${user}@${host}";
        value = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor arch;
          extraSpecialArgs = {inherit inputs outputs user host arch;};
          modules = [
            ../home-manager/${user}/${host}.nix
          ];
        };
      })
      configuredHosts
    );

  # =========================== Helpers ============================ #

  pkgsFor = system: inputs.nixpkgs.legacyPackages.${system};

  filesIn = dir: (map (fname: dir + "/${fname}")
    (builtins.attrNames (builtins.readDir dir)));

  dirsIn = dir:
    inputs.nixpkgs.lib.filterAttrs (name: value: value == "directory")
    (builtins.readDir dir);

  fileNameOf = path: (builtins.head (builtins.split "\\." (baseNameOf path)));

  # ========================== Extenders =========================== #

  # Evaluates nixos/home-manager module and extends it's options / config
  extendModule = {path, ...} @ args: {pkgs, ...} @ margs: let
    eval =
      if (builtins.isString path) || (builtins.isPath path)
      then import path margs
      else path margs;
    evalNoImports = builtins.removeAttrs eval ["imports" "options"];

    extra =
      if (builtins.hasAttr "extraOptions" args) || (builtins.hasAttr "extraConfig" args)
      then [
        ({...}: {
          options = args.extraOptions or {};
          config = args.extraConfig or {};
        })
      ]
      else [];
  in {
    imports =
      (eval.imports or [])
      ++ extra;
    options =
      if builtins.hasAttr "optionsExtension" args
      then (args.optionsExtension (eval.options or {}))
      else (eval.options or {});
    config =
      if builtins.hasAttr "configExtension" args
      then (args.configExtension (eval.config or evalNoImports))
      else (eval.config or evalNoImports);
  };

  # Applies extendModules to all modules
  # modules can be defined in the same way
  # as regular imports, or taken from "filesIn"
  extendModules = extension: modules:
    map
    (f: let
      name = fileNameOf f;
    in (extendModule ((extension name) // {path = f;})))
    modules;
}
