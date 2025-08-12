# Configuring fingerprint
{
  config,
  pkgs,
  lib,
  ...
}: {
  services.fprintd = {
    enable = true;
    # tod = {
    #   enable = true;
    #   driver = pkgs.libfprint-2-tod1-goodix;
    # };
  };

  # Edit sudo settings
  security.pam.services.sudo.text = ''
    auth      sufficient  pam_unix.so try_first_pass likeauth
    auth      [success=done default=ignore open_err=ignore module_unknown=ignore service_err=ignore system_err=ignore authinfo_unavail=ignore] pam_fprintd.so timeout=2
    account   include     system-auth
    password  include     system-auth
    session   include     system-auth
  '';
}
