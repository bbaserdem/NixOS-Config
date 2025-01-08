# Audio scripts; standalone lossless conversion from wav to flac
{pkgs, ...} @ myPkgs: let
  find = "${pkgs.findutils}/bin/find";
  flac-2-flac = "${myPkgs.flac-2-flac}/bin/audio-convert_flac-2-flac";
  aiff-2-flac = "${myPkgs.aiff-2-flac}/bin/audio-convert_aiff-2-flac";
  wav-2-flac = "${myPkgs.wav-2-flac}/bin/audio-convert_wav-2-flac";
  parallel = "${pkgs.parallel}/bin/parallel";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
  pkgs.writeShellScriptBin "audio-reencodeLossless" ''
      if [ -n "''${1}" ] ; then
          input_dir="''${1}"
      else
          input_dir="$(pwd)"
      fi
      [ -d "''${input_dir}" ] || echo "Directory ''${input_dir} does not exist, or is not a directory."

    # Run scripts on all files under these directories
      ${find} "''${input_dir}" -type f -name '*.flac' | ${parallel} ${flac-2-flac} '{}'
      ${find} "''${input_dir}" -type f -name '*.aiff' | ${parallel} ${aiff-2-flac} '{}'
      ${find} "''${input_dir}" -type f -name '*.wav'  | ${parallel} ${wav-2-flac}  '{}'

    # Alert that conversion is done
      ${notify-send} "Lossless re-encoding is done!" -i dialog-info
  ''
