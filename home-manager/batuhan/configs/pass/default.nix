# Syncthing
{
  config,
  pkgs,
  ...
}: {
  services.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [
      exts.pass-checkup
      exts.pass-tomb
      exts.pass-genphrase
      exts.pass-update
    ]);
    settings = {
      PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
      PASSWORD_STORE_CLIP_TIME = "30";
      PASSWORD_STORE_GENERATED_LENGTH = "16";
    };
  };
}
