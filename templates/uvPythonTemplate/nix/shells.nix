# shell.nix
{
  pkgs,
  inputs,
  system,
  uvBoilerplate,
  projectName,
  ...
}: let
  # UV stuff
  inherit (uvBoilerplate) uvShellSet;

  # Shell aliases
  # Function to create script
  mkScript = name: text: let
    script = pkgs.writeShellScriptBin name text;
  in
    script;
  scripts = [
    #(mkScript "<Alias>" "<cmd> \"$@\"")
  ];

  # Default shell
  defaultPackages = with pkgs; [
    scripts
    git
    nodePackages_latest.nodejs
    uv
    # Grab build tools
    coreutils # Basic file, shell and text manipulation utilities
    findutils # Find, locate, and xargs commands
    gnugrep # GNU grep, egrep and fgrep
    gnused # GNU stream editor
    ripgrep # Fast line-oriented search tool
    fd # Simple, fast and user-friendly alternative to find
    bat # Cat clone with syntax highlighting
    eza # Modern replacement for ls
    htop # Interactive process viewer
    jq # Lightweight JSON processor
    watch # Execute a program periodically
    curl # Command line tool for transferring data
    wget # Internet file retriever
    tree # Display directories as trees
    unzip # Unzip utility
    zip # Zip utility
  ];
  defaultHooks = ''
  '';
  defaultEnv = {};
in {
  # Main dev shell, contain everything
  default = pkgs.mkShell {
    packages =
      uvShellSet.packages
      ++ defaultPackages;
    env =
      uvShellSet.env
      // defaultEnv;
    # Shell hooks
    shellHook =
      uvShellSet.shellHook
      + "\n"
      + defaultHooks;
  };
}
