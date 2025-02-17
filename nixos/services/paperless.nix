# Configures paperless
{config, ...}: let
  myUser = config.myNixOS.userName;
in {
  # Import our SOPS key
  sops.secrets."paperless" = {
    mode = "0400";
    owner = myUser;
  };

  # Configure paperless
  services.paperless = {
    enable = true;
    dataDir = "/home/data/Media/Documents/Paperless";
    mediaDir = "${config.services.paperless.dataDir}/media";
    consumptionDir = "${config.services.paperless.dataDir}/consume";
    consumptionDirIsPublic = false;
    user = myUser;
    passwordFile = config.sops.secrets.paperless.path;
    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "eng+tur";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };
}
