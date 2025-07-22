{pkgs, ...}: let
  to-opus = pkgs.callPackage ./convert2opus.nix {};
  flac-2-opus = pkgs.callPackage ./convert_flac-2-opus.nix {};
  m4a-2-opus = pkgs.callPackage ./convert_m4a-2-opus.nix {};
  mp3-2-opus = pkgs.callPackage ./convert_mp3-2-opus.nix {};
  ogg-2-opus = pkgs.callPackage ./convert_ogg-2-opus.nix {};
  aiff-2-flac = pkgs.callPackage ./convert_aiff-2-flac.nix {};
  flac-2-flac = pkgs.callPackage ./convert_flac-2-flac.nix {};
  wav-2-flac = pkgs.callPackage ./convert_wav-2-flac.nix {};
  reencodeLossless = pkgs.callPackage ./reencodeLossless.nix {
    inherit
      aiff-2-flac
      flac-2-flac
      wav-2-flac
      ;
  };
  reencodeLossy = pkgs.callPackage ./reencodeLossy.nix {
    inherit
      flac-2-opus
      m4a-2-opus
      mp3-2-opus
      ogg-2-opus
      ;
  };
  syncDAC = pkgs.callPackage ./syncDAC.nix {};
  playlist-2-android = pkgs.callPackage ./playlist-2-android.nix {};
in (pkgs.symlinkJoin {
  name = "user-audio";
  paths = [
    to-opus
    flac-2-opus
    m4a-2-opus
    mp3-2-opus
    ogg-2-opus
    aiff-2-flac
    flac-2-flac
    wav-2-flac
    reencodeLossless
    reencodeLossy
    syncDAC
    playlist-2-android
  ];
})
