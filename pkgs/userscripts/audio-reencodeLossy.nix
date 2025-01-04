# Audio scripts; standalone lossless conversion from wav to flac
{pkgs}: let
  find = "${pkgs.findutils}/bin/find";
  flac-2-opus = "${pkgs.user-audio-flac-2-opus}/bin/audio-convert_flac-2-opus";
  mp3-2-opus = "${pkgs.user-audio-mp3-2-opus}/bin/audio-convert_mp3-2-opus";
  m4a-2-opus = "${pkgs.user-audio-m4a-2-opus}/bin/audio-convert_m4a-2-opus";
  ogg-2-opus = "${pkgs.user-audio-ogg-2-opus}/bin/audio-convert_ogg-2-opus";
  parallel = "${pkgs.parallel}/bin/parallel";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
  pkgs.writeShellScriptBin "audio-reencodeLossy" ''
      if [ -n "''${1}" ] ; then
          input_dir="''${1}"
      else
          input_dir="$(pwd)"
      fi
      [ -d "''${input_dir}" ] || echo "Directory ''${input_dir} does not exist, or is not a directory."

    # Run scripts on all files under these directories
      ${find} "''${input_dir}" -type f -name '*.flac' | ${parallel} ${flac-2-opus}  '{}'
      ${find} "''${input_dir}" -type f -name '*.mp3'  | ${parallel} ${mp3-2-opus}   '{}'
      ${find} "''${input_dir}" -type f -name '*.m4a'  | ${parallel} ${m4a-2-opus}   '{}'
      ${find} "''${input_dir}" -type f -name '*.ogg'  | ${parallel} ${ogg-2-opus}   '{}'

    # Alert that conversion is done
      ${notify-send} "Lossy re-encoding is done!" -i dialog-info
  ''
