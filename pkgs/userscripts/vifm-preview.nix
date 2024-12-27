# Audio scripts; standalone lossless conversion from wav to flac
{pkgs}: let
  soxi = "${pkgs.sox}/bin/soxi";
  ffprobe = "${pkgs.ffmpeg}/bin/ffprobe";
  man = "${pkgs.man-db}/bin/man";
  col = "${pkgs.util-linux}/bin/col";
  patool = "${pkgs.patool}/bin/patool";
  catdoc = "${pkgs.catdoc}/bin/catdoc";
  docx2txt = "${pkgs.python312Packages.docx2txt}/bin/docx2txt}";
in
  pkgs.writeShellScriptBin "vifm-preview" ''
    # Input file
    action="''${1}"
    input_file="''${2}"
    
    # Switch case
    case "$action" in
      flac)
        ${soxi} "''${input_file}" 2>&1
        ;;
      opus)
        ${ffprobe} -pretty "''${input_file}" 2>&1
        ;;
      manual)
        ${man} "./''${input_file}" | ${col} -b
        ;;
      archive)
        ${patool} list "''${input_file}"
        ;;
      doc)
        ${catdoc} "''${input_file}"
        ;;
      docx)
        ${docx2txt} "''${input_file}"
        ;;
      *)
    esac
  ''
