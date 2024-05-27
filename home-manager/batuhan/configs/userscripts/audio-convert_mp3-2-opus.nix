# Audio scripts; convert flac to opus with good bitrater
{pkgs}:
let
  xdg-user-dir = "${pkgs.xdg-user-dirs}/bin/xdg-user-dir";
  exiftool = "${pkgs.exiftool}/bin/exiftool";
  ffmpeg = "${pkgs.ffmpeg}/bin/ffmpeg";
in pkgs.writeShellScriptBin "audio-convert_mp3-2-opus" ''
  input_file="''${1}"
  downl_dir="$(${xdg-user-dir} DOWNLOAD)"
  [ -z "''${downl_dir}" ] && downl_dir="''${HOME}/Downloads"
  backup_dir="''${downl_dir}/Mp3ToOpus-backup"
  mkdir --parents "''${backup_dir}"

  # Guard
  [ -f "''${input_file}" ] || exit
  [ "''${input_file:(-4)}" == '.mp3' ] || exit

  # Get new filename by removing the last 4 letters
  this_name="$(basename "''${input_file}")"
  this_dir="$(dirname "''${input_file}")"
  output_file="''${this_dir}/''${this_name::-4}.opus"
  backup_file="''${backup_dir}/''${this_name}"

  # Get the bitrate of this file
  this_rate="$(${exiftool} -AudioBitrate "''${input_file}" | \
    sed '-|[^0-9]*\([0-9]\+\) kbps.*|\1|')"
  # Choose output bitrate
  if    [ "''${this_rate}" -ge 300 ] ; then
    output_rate='192k'
  elif  [ "''${this_rate}" -ge 200 ] ; then
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
