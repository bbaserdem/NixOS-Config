# Configuring discovery
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
    # This is the part of configuring extra services
    # Here is my old nfs share for my trials with kodi
    #extraServiceFiles = {
    #  nfs = ''
    #  <?xml version="1.0" standalone='no'?>
    #    <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
    #    <service-group>
    #      <name replace-wildcards="yes">NFS Public Share of sbp on %h</name>
    #      <service>
    #        <type>_nfs._tcp</type>
    #        <port>2049</port>
    #        <txt-record>path=/srv/nfs/sbp</txt-record>
    #      </service>
    #    </service-group>
    #  '';
    #};
  };
}
