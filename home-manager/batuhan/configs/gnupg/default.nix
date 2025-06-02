# Configuring GPG
{pkgs, ...}: {
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableSshSupport = true;
    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;
    maxCacheTtl = 86400;
    maxCacheTtlSsh = 86400;
    extraConfig = "allow-loopback-pinentry";
  };
}
