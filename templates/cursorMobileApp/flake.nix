{
  description = "Flake Mobile app development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        # Nixpkgs, we need unfree packages, and accepted licences
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          android_sdk.accept_license = true;
        };
        # Modify this as needed, as of 06-2025 sdk 36 is the most current sdk
        # Play store requires 34 as a hard requirement
        # I'm using the most recent versions from nixpkgs-unstable
        cmdlineToolsVersion = "13.0";
        platformToolsVersion = "latest";
        buildToolsVersion = "35.0.0";
        ndkVersion = "27.0.12077973"
        cmakeVersion = "3.22.1";
        # Creating our android dev environment
        androidEnv = pkgs.androidenv.override {licenseAccepted = true;};
        androidComposition = androidEnv.composeAndroidPackages {
          inherit cmdLineToolsVersion platformToolsVersion;
          buildToolsVersions = [buildToolsVersion];
          platformVersions = ["33" "34" "35" "36"];
          abiVersions = ["armeabi-v7a" "arm64-v8a" "x86_64"];
          includeNDK = true;
          ndkVersions = [ndkVersion];
          cmakeVersions = [cmakeVersion];
          includeSystemImages = true;
          systemImageTypes = ["google_apis" "google_apis_playstore"];
          includeEmulator = true;
          useGoogleAPIs = true;
          extraLicenses = [
            # Grab all licenses
            "android-googletv-license"
            "android-sdk-arm-dbt-license"
            "android-sdk-license"
            "android-sdk-preview-license"
            "google-gdk-license"
            "intel-android-extra-license"
            "intel-android-sysimage-license"
            "mips-android-sysimage-license"
          ];
        };
        # RAG toolkit with python; as of 06-2025 python 3.13 is the version with pkgs
        devPython = pkgs.python313.withPackages (python-pkgs:
          with python-pkgs; [
            # Pinecone packages
            pinecone-client
            pinecone-plugin-inference
            pinecone-plugin-interface
            # Langsmith packages
            langsmith
            langchain-anthropic
            langchain-aws
            langchain-community
            langchain-openai
            langchain-perplexity
            langchain-core
            langchain-tests
            # System packages
            python-dotenv
            jupyter
            ipython
          ]);
      in {
        devShells.default = pkgs.mkShell rec {
            ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
            ANDROID_SDK_ROOT = "${ANDROID_HOME}";
            ANDROID_NDK_ROOT = "${ANDROID_HOME}/ndk-bundle";
            CMDLINE_TOOLS_ROOT = "${androidSdk}/libexec/android-sdk/cmdline-tools/8.0";
            JAVA_HOME = jdk17.home;
            FLUTTER_ROOT = pkgs.flutter;
            DART_ROOT = "${pkgs.flutter}/bin/cache/dart-sdk";
            GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/${buildToolsVersion}/aapt2";
            # emulator related: try using wayland, otherwise fall back to X.
            # NB: due to the emulator's bundled qt version, it currently does not start with QT_QPA_PLATFORM="wayland".
            # Maybe one day this will be supported.
            QT_QPA_PLATFORM = "wayland;xcb"; 

            # Android Emulator Performance Optimizations
            # Enable KVM hardware acceleration for faster emulation
            # Note: ANDROID_EMULATOR_USE_SYSTEM_LIBS is NOT set in NixOS as it conflicts with Nix store paths
            QEMU_OPTS = "-machine accel=kvm"; 

            buildInputs = with pkgs; [
              flutter
              qemu_kvm
              gradle
              jdk17
              mesa-demos
              firebase-tools
              ffmpeg
              libsecret
              pkg-config
              # Custom environments
              devPython
              androidSdk
              gtk3
            ];
            # emulator related: vulkan-loader and libGL shared libs are necessary for hardware decoding
            LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [vulkan-loader libGL]}";
            # Globally installed packages, which are installed through `dart pub global activate package_name`,
            # are located in the `$PUB_CACHE/bin` directory.
            shellHook = ''
              # Dart/Flutter pub cache setup
              if [ -z "$PUB_CACHE" ]; then
                export PATH="$PATH:$HOME/.pub-cache/bin"
              else
                export PATH="$PATH:$PUB_CACHE/bin"
              fi

              # Add Android cmdline-tools to PATH for Flutter
              export PATH="$PATH:${androidSdk}/libexec/android-sdk/cmdline-tools/8.0/bin"

              # Add cmake to path
              export PATH="$(echo "$ANDROID_HOME/cmake/${cmakeVersion}".*/bin):$PATH"

              # Write out local.properties for Android Studio.
              cat <<EOF > local.properties
              # This file was automatically generated by nix-shell.
              sdk.dir=$ANDROID_SDK_ROOT
              ndk.dir=$ANDROID_NDK_ROOT
              cmake.dir=$cmake_root
              EOF
            '';
          };
;
      }
    );
}
