# Configuring Security stuff
{...}: {
  imports = [
    ./gpg.nix
    ./keepassxc.nix
    ./sops.nix
    ./ssh.nix
  ];
}
