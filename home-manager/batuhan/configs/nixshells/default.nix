# Configuring git
{
  pkgs,
  config,
  ...
}: {
  # Matlab configuration
  xdg.configFile."matlab/nix.sh".text = ''
    INSTALL_DIR=$HOME/Projects/MatlabInstall/MATLAB-R2024a
  '';
}
