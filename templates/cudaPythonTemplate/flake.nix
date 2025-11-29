{
  description = "Develop Python on Nix with uv";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs) lib;

    forAllSystems = lib.genAttrs lib.systems.flakeExposed;
  in {
    devShells = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowAliases = true;
          };
        };
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # Packaging
            uv
            nodejs-slim
            pnpm
            python313Packages.huggingface-hub

            # CUDA support
            cudaPackages.cudatoolkit
            cudaPackages.cudnn
            cudaPackages.cuda_cudart
            cudaPackages.cutensor
            cudaPackages.libcublas
            cudaPackages.libcurand
            cudaPackages.libcusparse
            gcc13

            # OpenCV and computer vision
            opencv4

            # PyArrow dependencies
            arrow-cpp

            # FFmpeg for av package
            ffmpeg

            # PostgreSQL client libraries
            postgresql

            # Build tools and compilers
            pkg-config
            cmake
            ninja
            gcc

            # Additional system libraries
            zlib
            libjpeg
            libpng
            libtiff
            eigen

            # Essential GUI dependencies only (minimal set for PyQt5)
            glib # For PyQt5 libgthread-2.0.so.0 error
            glibc # Additional C library support
            libGL # For PyQt5 OpenGL support
            libxcb # For Qt5 XCB platform plugin
            xcbutilxrm # XCB utilities
            libxkbcommon # For XKB support
            fontconfig # For PyQt5 XCB plugin libfontconfig.so.1
            freetype # For PyQt5 XCB plugin libfreetype.so.6
            dbus # For PyQt5 XCB plugin libdbus-1.so.3

            # Complete XCB and X11 libraries needed by Qt5 XCB plugin
            xorg.libX11
            xorg.libXi
            xorg.libXrender
            xorg.libXext
            xorg.libXrandr
            xorg.libXfixes
            xorg.libXcursor
            xorg.libXcomposite
            xorg.libXdamage
            xorg.libXinerama
            xorg.libXau
            xorg.libXdmcp
            xorg.xcbutil
            xorg.xcbutilimage
            xorg.xcbutilkeysyms
            xorg.xcbutilrenderutil
            xorg.xcbutilwm

            tk # For matplotlib TkAgg backend
            tcl # Required by tk
          ];

          shellHook = ''
                # Set CC to GCC 13 to avoid the version mismatch error
                export PATH=${pkgs.gcc13}/bin:$PATH

            # Essential GUI environment variables only
            export TCL_LIBRARY=${pkgs.tcl}/lib/tcl8.6
            export TK_LIBRARY=${pkgs.tk}/lib/tk8.6

            # Don't set QT_PLUGIN_PATH - let PyQt5 use its own plugins to avoid version conflicts
            # The PyQt5 plugins are compatible with the PyQt5 version we installed
            # export QT_PLUGIN_PATH=${pkgs.qt5.qtbase}/lib/qt-5.15.17/plugins
          '';

          # Cuda env variables
          CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
          CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
          CUDA_ROOT = "${pkgs.cudaPackages.cudatoolkit}";

          # Set CC to GCC 13 to avoid the version mismatch error
          CC = "${pkgs.gcc13}/bin/gcc";
          CXX = "${pkgs.gcc13}/bin/g++";

          # Environment variables to help packages find system libraries
          GDAL_DATA = "${pkgs.gdal}/share/gdal";
          PROJ_LIB = "${pkgs.proj}/share/proj";
          GDAL_LIBRARY_PATH = "${pkgs.gdal}/lib";
          GEOS_LIBRARY_PATH = "${pkgs.geos}/lib";

          # OpenCV
          OpenCV_DIR = "${pkgs.opencv4}/lib/cmake/opencv4";
          OPENCV_INCLUDE_DIRS = "${pkgs.opencv4}/include/opencv4";

          # Arrow
          ARROW_HOME = "${pkgs.arrow-cpp}";

          # Library path including CUDA and essential GUI libraries
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
            "/run/opengl-driver"
            cudaPackages.cudatoolkit
            cudaPackages.cudnn
            cudaPackages.cutensor
            cudaPackages.libcublas
            cudaPackages.libcurand
            cudaPackages.libcusparse

            # Essential GUI libraries only (minimal set for PyQt5)
            glib # For PyQt5 libgthread-2.0.so.0
            glibc # Additional C library support
            libGL # For PyQt5 OpenGL support
            libxcb # For Qt5 XCB platform plugin
            xcbutilxrm # XCB utilities
            libxkbcommon # For XKB support
            fontconfig # For PyQt5 XCB plugin libfontconfig.so.1
            freetype # For PyQt5 XCB plugin libfreetype.so.6
            dbus # For PyQt5 XCB plugin libdbus-1.so.3

            # Complete XCB and X11 libraries needed by Qt5 XCB plugin
            xorg.libX11
            xorg.libXi
            xorg.libXrender
            xorg.libXext
            xorg.libXrandr
            xorg.libXfixes
            xorg.libXcursor
            xorg.libXcomposite
            xorg.libXdamage
            xorg.libXinerama
            xorg.libXau
            xorg.libXdmcp
            xorg.xcbutil
            xorg.xcbutilimage
            xorg.xcbutilkeysyms
            xorg.xcbutilrenderutil
            xorg.xcbutilwm
            libxkbcommon

            tk # For matplotlib TkAgg backend
            tcl # Required by tk
          ]);

          # Set LIBRARY_PATH to help the linker find the CUDA static libraries
          LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
            cudaPackages.cudatoolkit
          ]);

          # PKG_CONFIG_PATH for all libraries
          PKG_CONFIG_PATH =
            "${pkgs.gdal}/lib/pkgconfig"
            + ":"
            + "${pkgs.opencv4}/lib/pkgconfig"
            + ":"
            + "${pkgs.arrow-cpp}/lib/pkgconfig"
            + ":"
            + "${pkgs.postgresql}/lib/pkgconfig";
        };
      }
    );
  };
}
