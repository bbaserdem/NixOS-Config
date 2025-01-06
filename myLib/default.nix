# My library of stuff to cut out boilerplate
# Mostly from https://github.com/vimjoyer/nixconf/tree/main/myLib
# Wants the rootpath variable to simplify path input to this function
{
  inputs,
  rootPath,
  ...
}: let
  utils = inputs.flake-utils.lib;
  # Make ourselves available so these functions can be used in further modules
  outputs = inputs.self.outputs;
  # Some quick default library functions
  mergeAttrsList = inputs.nixpkgs.lib.attrsets.mergeAttrsList;
  forEach = inputs.nixpkgs.lib.lists.forEach;
  # Also make us recursive so the functions can refer to one another
in rec {
  # ================================================================ #
  # =                            My Lib                            = #
  # ================================================================ #

  # ======================= Available Hosts ======================== #

  configuredHosts = [
    {   # Virtualbox setup
      host = "umay";
      arch = utils.system.x86_64-linux;
    } { # Home PC
      host = "yertengri";
      arch = utils.system.x86_64-linux;
    } { # Laptop
      host = "yel-ana";
      arch = utils.system.x86_64-linux;
    }
  ];

  # ========================== Buildables ========================== #

  # Generate NixOS configs for hosts
  mkSystems = names: inputs.nixpkgs.lib.genAttrs names (name:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs;
      };
      modules = [
        # Default modules mean for all systems
        (rootPath + /nixos)
        # Host specific modules
        (rootPath + /nixos/hosts/${name})
      ];
    });

  # Generate standalone home-manager configs
  mkConfiguredUser = user: builtins.listToAttrs(
    map ({host, arch}: {
      name = "${user}@${host}";
      value = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor arch;
        modules = [
          (rootPath + /home-manager/${user}/${host}.nix)
          outputs.homeManagerModules.default
        ];
        extraSpecialArgs = { inherit inputs outputs; };
      };
    }) configuredHosts
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
