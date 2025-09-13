# Configuring Security stuff
{inputs, ...}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./gpg.nix
    ./keepassxc.nix
    ./sops.nix
    ./ssh.nix
  ];
}
