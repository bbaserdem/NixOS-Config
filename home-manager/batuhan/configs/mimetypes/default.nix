# Configuring mimetypes
{
  pkgs,
  config,
  ...
}: {
  # Add XDG Shared MIME stuff
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    # Default applications to launch stuff with
    defaultApplications = {
        # Documents
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "image/vnd.djvu+multipage" = "zathura-djvu.desktop";
        "text/htm" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/default" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/msword" = "libreoffice-writer.desktop";
        # Text files
        "text/plain" = "nvim.desktop";
        "text/css" = "nvim.desktop";
        "text/x-tex" = "nvim.desktop";
        # Images
        "image/gif" = "vimiv.desktop";
        "image/jpg" = "vimiv.desktop";
        "image/jpeg" = "vimiv.desktop";
        "image/png" = "vimiv.desktop";
        "image/svg" = "vimiv.desktop";
        "image/webm" = "vimiv.desktop";
        "image/raw" = "darktable.desktop";
        # Videos
        "video/x-msvideo" = "smplayer.desktop";
        "video/x-matroska" = "smplayer.desktop";
        "video/x-ms-asf" = "smplayer.desktop";
        "video/x-ms-wmv" = "smplayer.desktop";
        "video/x-theora" = "smplayer.desktop";
        "video/x-ogm" = "smplayer.desktop";
        "video/ogg" = "smplayer.desktop";
        "video/avi" = "smplayer.desktop";
        "video/flv" = "smplayer.desktop";
        "video/mpeg" = "smplayer.desktop";
        "video/vnd.rn-realvideo" = "smplayer.desktop";
        "video/mp4" = "smplayer.desktop";
        "video/quicktime" = "smplayer.desktop";
        "video/webm" = "smplayer.desktop";
        "video/mkv" = "smplayer.desktop";
        # Other stuff
        "x-scheme-handler/rdp" = "org.remmina.Remmina.desktop";
        "x-scheme-handler/spice" = "org.remmina.Remmina.desktop";
        "x-scheme-handler/vnc" = "org.remmina.Remmina.desktop";
        "x-scheme-handler/remmina" = "org.remmina.Remmina.desktop";
        "application/x-remmina" = "org.remmina.Remmina.desktop";
    };
    associations = {
      # Added associations; associate file types with these apps
      added = {
        # Image associations
        "image/gif+jpg+jpeg+png+svg+xml+webm+raw+dng+x-adobe-dng" = "vimiv.desktop";
        "image/raw+dng" = "darktable.desktop";
        # Video associations
        "video/ogg+avi+flv+mpeg+vnd.rn-realvideo+mp4+quicktime+webm+mkv" = "smplayer.desktop";
        "video/x-msvideo+x-matroska+x-ms-asf+x-ms-wmv+x-theora+x-ogm" = "smplayer.desktop";
        # Audio associations
        "audio/mp4+mpeg+x-opus+ogg+flac+x-vorbis" = "smplayer.desktop";
        # Document types
        "application/msword" = "libreoffice-writer.desktop";
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "libreoffice-writer.desktop";
        "application/vnd.oasis.opendocument.presentation" = [
          "libreoffice-impress.desktop"
          "org.pwmt.zathura-cb.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "libreoffice-calc.desktop";
        "application/vnd.oasis.opendocument.spreadsheet" = "libreoffice-calc.desktop";
        "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" "firefox.desktop" ];
        "image/vnd.djvu+multipage" = "zathura-djvu.desktop";
        "text/plain+css" = "nvim.desktop";
        # Web stuff
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "inode/directory" = "nnn.desktop";
        "x-scheme-handler/http+https" = [ "org.qutebrowser.qutebrowser.desktop" "firefox.desktop" ];
        # Remotes
        "application/x-remmina" = "org.remmina.Remmina.desktop";
        "x-scheme-handler/rdp+spice+vnc+remmina" = "org.remmina.Remmina.desktop";
      };
    };
  };
}
