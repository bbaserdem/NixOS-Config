# My library of stuff to cut out boilerplate
# Mostly from https://github.com/vimjoyer/nixconf/tree/main/myLib
# Wants the rootpath variable to simplify path input to this function

{inputs, rootPath}: let
  # Make ourselves available so these functions can be used in further modules
  myLib = (import ./default.nix) {inherit inputs rootPath;};
  # Make ourselves available so these functions can be used in further modules
  outputs = inputs.self.outputs;
in rec {
  # ================================================================ #
  # =                            My Lib                            = #
  # ================================================================ #

  # ============================ Systems =========================== #

  # List of systems that our nix flake will build for
  systems = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
  ];

  # Generate attribute set function that will apply this to our systems
  forAllSystems = inputs.nixpkgs.lib.genAttrs systems;

  # ======================= Package Helpers ======================== #

  pkgsFor = sys: inputs.nixpkgs.legacyPackages.${sys};

  # ========================== Buildables ========================== #

  # Generate standardized config for host
  mkSystem = name:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs myLib rootPath;
      };
      modules = [
        ( rootPath + /nixos/hosts/${name} )
        outputs.nixosModules.default
      ];
    };

  # Generate standardized config for user and host
  mkHome = sys: name: host:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor sys;
      extraSpecialArgs = {
        inherit inputs outputs myLib rootPath;
      };
      modules = [
        ( rootPath + /home/users/${name}/${host}.nix )
        outputs.homeManagerModules.default
      ];
    };

  # =========================== Helpers ============================ #

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

  # ============================ Shell ============================= #
  pkgsForAllSystems = pkgs: forAllSystems
    (system: pkgs inputs.nixpkgs.legacyPackages.${system});
}
