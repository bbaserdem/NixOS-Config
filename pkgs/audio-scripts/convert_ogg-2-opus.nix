# Audio scripts; convert flac to opus with good bitrater
{pkgs}: let
  xdg-user-dir = "${pkgs.xdg-user-dirs}/bin/xdg-user-dir";
  ffmpeg = "${pkgs.ffmpeg}/bin/ffmpeg";
  ffprobe = "${pkgs.ffmpeg}/bin/ffprobe";
in
  pkgs.writeShellScriptBin "audio-convert_ogg-2-opus" ''
    input_file="''${1}"
    downl_dir="$(${xdg-user-dir} DOWNLOAD)"
    [ -z "''${downl_dir}" ] && downl_dir="''${HOME}/Downloads"
    backup_dir="''${downl_dir}/OggToOpus-backup"
    mkdir --parents "''${backup_dir}"

    # Guard
    [ -f "''${input_file}" ] || exit
    [ "''${input_file:(-4)}" == '.ogg' ] || exit

    # Get new filename by removing the last 4 letters
    this_name="$(basename "''${input_file}")"
    this_dir="$(dirname "''${input_file}")"
    output_file="''${this_dir}/''${this_name::-5}.opus"
    backup_file="''${backup_dir}/''${this_name}"

    # Get the bitrate of the file
    this_rate="$(${ffprobe} -v quiet -select_streams a:0 -show_entries \
      stream=bit_rate -of default=noprint_wrappers=1 "''${input_file}" | \
      sed --quiet 's|bit_rate=||p')"
    # Choose output bitrate
    if    [ "''${this_rate}" -ge 250000 ] ; then
        output_rate='256k'
    elif  [ "''${this_rate}" -ge 120000 ] ; then
        output_rate='128k'
    else
        output_rate='96k'
    fi

    # Do conversion, and if successful move old file to backup
    ${ffmpeg} \
      -i "''${input_file}" \
      -codec:a libopus -b:a "''${output_rate}" -vbr on \
      "''${output_file}" && \
      mv "''${input_file}" "''${backup_file}"
  ''
