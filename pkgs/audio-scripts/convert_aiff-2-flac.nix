# Audio scripts; standalone lossless conversion from aiff to flac
{pkgs}: let
  xdg-user-dir = "${pkgs.xdg-user-dirs}/bin/xdg-user-dir";
  ffmpeg = "${pkgs.ffmpeg}/bin/ffmpeg";
in
  pkgs.writeShellScriptBin "audio-convert_aiff-2-flac" ''
    input_file="''${1}"
    downl_dir="$(${xdg-user-dir} DOWNLOAD)"
    [ -z "''${downl_dir}" ] && downl_dir="''${HOME}/Downloads"
    backup_dir="''${downl_dir}/AiffToFlac-backup"
    mkdir --parents "''${backup_dir}"

    # Guard
    [ -f "''${input_file}" ] || exit
    [ "''${input_file:(-5)}" == '.aiff' ] || exit

    # Get new filename by removing the last 4 letters
    this_name="$(basename "''${input_file}")"
    this_dir="$(dirname "''${input_file}")"
    output_file="''${this_dir}/''${this_name::-5}.flac"
    backup_file="''${backup_dir}/''${this_name}"

    # Do conversion, and if successful move old file to backup
    ${ffmpeg} \
      -i "''${input_file}" \
      -codec:a flac -compression_level 12 \
      "''${output_file}" && \
      mv "''${input_file}" "''${backup_file}"
  ''
