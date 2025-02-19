# Audio scripts; standalone lossless conversion from wav to flac
{pkgs}: let
  stat = "${pkgs.coreutils-full}/bin/stat";
  mkdir = "${pkgs.coreutils-full}/bin/mkdir";
  readlink = "${pkgs.coreutils-full}/bin/readlink";
  sha256sum = "${pkgs.coreutils-full}/bin/sha256sum";
  awk = "${pkgs.gawk}/bin/gawk";
  kitten = "${pkgs.kitty}/bin/kitten";
  identify = "${pkgs.imagemagick}/bin/identify";
  convert = "${pkgs.imagemagick}/bin/convert";
  ffmpegthumbnailer = "${pkgs.ffmpegthumbnailer}/bin/ffmpegthumbnailer";
  epub-thumbnailer = "${pkgs.epub-thumbnailer}/bin/epub-thumbnailer";
  pdftoppm = "${pkgs.poppler_utils}/bin/pdftoppm";
  ffmpeg = "${pkgs.ffmpeg}/bin/ffmpeg";
  fontpreview = "${pkgs.fontpreview}/bin/fontpreview";
in
  pkgs.writeShellScriptBin "vifm-visualpreview" ''
    # Create cache
    [ -d "''${XDG_CACHE_HOME}/vifm" ] || ${mkdir} --parents "''${XDG_CACHE_HOME}/vifm"
    action="''${1}"
    width="''${2}"
    height="''${3}"
    xpos="''${4}"
    ypos="''${5}"
    input_file="''${6}"
    no_detach="''${7}"

    # Some config options
    thumbnail_ext="jpg"
    thumbnail_id="$(${stat} --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- \
      "$(${readlink} -f "''${PWD}/''${input_file}")" | \
      ${sha256sum} | \
      ${awk} '{print $1}')"
    thumbnail_path="''${XDG_CACHE_HOME}/vifm"
    thumbnail_file="''${thumbnail_path}/''${thumbnail_id}.''${thumbnail_ext}"

    # Main image preview functions
    close_preview () {
      ${kitten} icat --clear --silent >/dev/tty </dev/tty "''${no_detach}"
      exit 0
    }
    show_preview () {
      input_file="$1"
      width="$2"
      height="$3"
      xpos="$4"
      ypos="$5"

      ${kitten} icat --silent --transfer-mode=file \
        --place=''${width}x''${height}@''${xpos}x''${ypos} \
        --scale-up "''${input_file}" >/dev/tty </dev/tty "''${no_detach}"
      exit 0
    }

    # File picker loop
    case "$action" in
      clear)
        close_preview
        ;;
      image)
        if [ ! -f "''${thumbnail_file}" ]; then
          imgwidth=$(${identify} -format '%w' "''${input_file}[0]")
          if [ "''${imgwidth}" -lt 1024 ]; then
            ${convert} "''${input_file}[0]" -strip -quality 50 -density 72 \
              "''${thumbnail_file}"
          elif [ "''${imgwidth}" -le 1920 ]; then
            ${convert} "''${input_file}[0]" -thumbnail '50%' -strip -quality 35 -density 72 \
              "''${thumbnail_file}"
          else
            ${convert} "''${input_file}[0]" -thumbnail 1024 -strip -quality 35 -density 72 \
              "''${thumbnail_file}"
          fi
        fi
        show_preview "''${thumbnail_file}" "''${width}" "''${height}" "''${xpos}" "''${ypos}"
        ;;
      video)
        if [ ! -f "''${thumbnail_file}" ]; then
          ${ffmpegthumbnailer} -i "''${input_file}" -o "''${thumbnail_file}" -s 0 -q 5
        fi
        show_preview "''${thumbnail_file}" "''${width}" "''${height}" "''${xpos}" "''${ypos}"
        ;;
      epub)
        if [ ! -f "''${thumbnail_file}" ]; then
          ${epub-thumbnailer} "''${input_file}" "''${thumbnail_file}" 1024
        fi
        show_preview "''${thumbnail_file}" "''${width}" "''${height}" "''${xpos}" "''${ypos}"
        ;;
      pdf)
        if [ ! -f "''${thumbnail_file}" ]; then
          ${pdftoppm} -jpeg -f 1 -singlefile "''${input_file}" "''${thumbnail_file%.''${thumbnail_ext}}"
        fi
        show_preview "''${thumbnail_file}" "''${width}" "''${height}" "''${xpos}" "''${ypos}"
        ;;
      audio)
        if [ ! -f "''${thumbnail_file}" ]; then
          ${ffmpeg} -i "''${input_file}" "''${thumbnail_file}" -y >/dev/null
        fi
        show_preview "''${thumbnail_file}" "''${width}" "''${height}" "''${xpos}" "''${ypos}"
        ;;
      font)
        if [ ! -f "''${thumbnail_file}" ]; then
          ${fontpreview} -i "''${input_file}" -o "''${thumbnail_file}"
        fi
        show_preview "''${thumbnail_file}" "''${width}" "''${height}" "''${xpos}" "''${ypos}"
        ;;
      *)
    esac
  ''
