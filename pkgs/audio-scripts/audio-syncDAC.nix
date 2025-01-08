# Script to sync music to my DAC device
{pkgs}: let
  rsync = "${pkgs.rsync}/bin/rsync";
in
  pkgs.writeShellScriptBin "audio-syncDAC" ''
    # Script to copy music from computer to USB DAC

    # Input device
    if [ -z "''${1}" ] ; then
      DEV_DEVICE="SBP-DAC"
    else
      DEV_DEVICE="''${1}"
    fi
    DEV_PATH="/run/media/$(whoami)/''${DEV_DEVICE}"
    if [ ! -d "''${DEV_PATH}" ] ; then
      echo "''${DEV_PATH} is not mounted!"
      exit 1
    fi

    # Music directory
    if [ ! -d "''${XDG_MUSIC_DIR}" ] ; then
      echo 'XDG_MUSIC_DIR needs to be set'
      exit 2
    else
      MUS_DIR="''${XDG_MUSIC_DIR}"
    fi

    # Use rsync to transfer music library
    ${rsync} \
      --archive \
      --delete \
      --delete-after \
      --human-readable \
      --partial \
      --log-file=/tmp/audio-syncDevice.log \
      --info=progress2 \
      "''${MUS_DIR}/" "''${DEV_PATH}/"
  ''
