# Script to convert playlists to android
{pkgs}: let
  mkdir = "${pkgs.coreutils-full}/bin/mkdir";
  cp = "${pkgs.coreutils-full}/bin/cp";
  sed = "${pkgs.gnused}/bin/sed";
in
  pkgs.writeShellScriptBin "audio-playlist-2-android" ''
    # Script to copy playlists to android so they can use the compressed file paths
    target_dir="''${HOME}/Shared/Android/Music/Playlists"
    source_dir="''${XDG_MUSIC_DIR}/Playlists"

    # Make sure directory exists, in case it doesn't exist yet
    ${mkdir} --parents "''${target_dir}"

    # Loop to force overwrite playlists, and then change extensions sensibly
    for source_file in "''${target_dir}/"* ; do
      target_file="''${target_dir}/$(basename "''${source_file}")"
      ${cp} --force "''${source_file}" "''${target_file}"
      ${sed} --in-place 's|\.flac$|.opus|' "''${target_file}"
    done
  ''
