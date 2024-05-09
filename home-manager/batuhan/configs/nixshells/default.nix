# Configuring git 
{
  pkgs,
  config,
  ...
}: {
  # Shell alias for conda
  xdg.dataFile."nixshells/conda-shell.nix".source = ./conda-shell.nix;
  programs.zsh.shellAliases.conda-shell = ''
    nix-shell "${config.xdg.dataHome}/nixshells/conda-shell.nix"
  '';
  # Matlab configuration
  xdg.configFile."matlab/nix.sh".text = ''
    INSTALL_DIR=$HOME/Projects/MatlabInstall/MATLAB-R2024a    
  '';
}
