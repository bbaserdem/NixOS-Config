# Configuring mimetypes
{
  lib,
  ...
}: let
  # Helper functions
  turnMimeappSetToString = mimeappSet: builtins.concatStringsSep "\n" (
    lib.attrsets.mapAttrsToList (name: value: let
      listValue =
        if builtins.isList value
        then builtins.concatStringsSep ";" value
        else value
      ;
    in "${name}=${listValue};") mimeappSet
  );
  generateDesktopMimeappFile = {
    browsApp,
    emailApp,
    phoneApp,
    imageApp,
    audioApp,
    videoApp,
    textsApp,
    pdfFtApp,
    filesApp,
    archvApp,
    gpsLcApp,
  }: ''
    [Default Applications]
    ${turnMimeappSetToString (import ./brows.nix browsApp)}
    ${turnMimeappSetToString (import ./email.nix emailApp)}
    ${turnMimeappSetToString (import ./phone.nix phoneApp)}
    ${turnMimeappSetToString (import ./image.nix imageApp)}
    ${turnMimeappSetToString (import ./audio.nix audioApp)}
    ${turnMimeappSetToString (import ./video.nix videoApp)}
    ${turnMimeappSetToString (import ./texts.nix textsApp)}
    ${turnMimeappSetToString (import ./pdfFt.nix pdfFtApp)}
    ${turnMimeappSetToString (import ./files.nix filesApp)}
    ${turnMimeappSetToString (import ./archv.nix archvApp)}
    ${turnMimeappSetToString (import ./gpsLc.nix gpsLcApp)}
  '';
in {
  # Add XDG Shared MIME stuff
  xdg.mime.enable = true;

  # Add desktop specific overrides as well
  xdg = {
    configFile."KDE-mimeapps.list".text = generateDesktopMimeappFile {
      browsApp = "firefox.desktop";
      emailApp = "org.kde.kmail2.desktop";
      phoneApp = "Zoom.desktop";
      imageApp = "org.kde.gwenview.desktop";
      audioApp = "vlc.desktop";
      videoApp = "org.kde.dragonplayer.desktop";
      textsApp = "org.kde.kwrite.desktop";
      pdfFtApp = "okularApplication_pdf.desktop";
      filesApp = "org.kde.dolphin.desktop";
      archvApp = "org.kde.ark.desktop";
      gpsLcApp = "marble_geo.desktop";
    };

    mimeApps = {
      enable = true;
      # Default applications to launch stuff with
      defaultApplications = {
        # Zathura has separate launchers depending
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "image/vnd.djvu" = "zathura-djvu.desktop";
        "image/vnd.djvu+multipage" = "zathura-djvu.desktop";
        # Let default handler be firefox, probably can handle
        "x-scheme-handler/default" = "firefox.desktop";
        "application/msword" = "libreoffice-writer.desktop";
        "x-scheme-handler/rdp" = "org.remmina.Remmina.desktop";
        "x-scheme-handler/spice" = "org.remmina.Remmina.desktop";
        "x-scheme-handler/vnc" = "org.remmina.Remmina.desktop";
        "x-scheme-handler/remmina" = "org.remmina.Remmina.desktop";
        "application/x-remmina" = "org.remmina.Remmina.desktop";
      } // (import ./brows.nix "firefox.desktop")
        // (import ./image.nix "vimiv.desktop")
        // (import ./audio.nix "vlc.desktop")
        // (import ./video.nix "smplayer.desktop")
        // (import ./texts.nix "nvim.desktop")
        ;
      associations = let
        browsApps = [
          "org.qutebrowser.qutebrowser.desktop"
          "firefox.desktop"
        ];
        imageApps = [
          "vimiv.desktop"
          "org.kde.gwenview.desktop"
        ];
        audioApps = [
          "vlc.desktop"
          "smplayer.desktop"
        ];
        videoApps = [
          "smplayer.desktop"
          "org.kde.dragonplayer.desktop"
        ];
        textsApps = [
          "nvim.desktop"
          "org.kde.kwrite.desktop"
        ];
        pdfFtApps = [
            "okularApplication_pdf.desktop"
            "firefox.desktop"
        ];
        filesApps = [
          "nnn.desktop"
          "vifm.desktop"
          "org.kde.dolphin.desktop"
        ];
        archvApps = [
          "org.gnome.FileRoller.desktop"
          "org.kde.ark.desktop"
        ];
        gpsLcApps = [
          "org.gnome.Maps.desktop"
          "marble_geo.desktop"
          "openstreetmap-geo-handler.desktop"
        ];
      in {
        # Added associations; associate file types with these apps
        added = {
          # Raw image processing with darktable
          "image/raw" = "darktable.desktop";
          "image/heif" = "darktable.desktop";
          "image/dng" = "darktable.desktop";
          "image/x-adobe-dng" = "darktable.desktop";
          # Document types
          "application/msword" = "libreoffice-writer.desktop";
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "libreoffice-writer.desktop";
          "application/vnd.oasis.opendocument.presentation" = [
            "libreoffice-impress.desktop"
            "org.pwmt.zathura-cb.desktop"
          ];
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "libreoffice-calc.desktop";
          "application/vnd.oasis.opendocument.spreadsheet" = "libreoffice-calc.desktop";
          # Djvu files, zathura has separate launchers for this
          "image/vnd.djvu" = "zathura-djvu.desktop";
          "image/vnd.djvu+multipage" = "zathura-djvu.desktop";
          # Remotes
          "application/x-remmina" = "org.remmina.Remmina.desktop";
          "x-scheme-handler/rdp" = "org.remmina.Remmina.desktop";
          "x-scheme-handler/spice" = "org.remmina.Remmina.desktop";
          "x-scheme-handler/vnc" = "org.remmina.Remmina.desktop";
          "x-scheme-handler/remmina" = "org.remmina.Remmina.desktop";
        } // (import ./brows.nix browsApps)
          // (import ./image.nix imageApps)
          // (import ./audio.nix audioApps)
          // (import ./video.nix videoApps)
          // (import ./texts.nix textsApps)
          // (import ./pdfFt.nix pdfFtApps)
          // (import ./files.nix filesApps)
          // (import ./archv.nix archvApps)
          // (import ./gpsLc.nix gpsLcApps)
          ;
      };
    };
  };
}
