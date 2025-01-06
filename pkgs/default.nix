# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}, ...}: rec {
  # example = pkgs.callPackage ./example { };

  # Audio related scripts
  user-audio-to-opus = pkgs.callPackage ./userscripts/audio-convert2opus.nix {};
  user-audio-flac-2-opus = pkgs.callPackage ./userscripts/audio-convert_flac-2-opus.nix {};
  user-audio-m4a-2-opus = pkgs.callPackage ./userscripts/audio-convert_m4a-2-opus.nix {};
  user-audio-mp3-2-opus = pkgs.callPackage ./userscripts/audio-convert_mp3-2-opus.nix {};
  user-audio-ogg-2-opus = pkgs.callPackage ./userscripts/audio-convert_ogg-2-opus.nix {};
  user-audio-aiff-2-flac = pkgs.callPackage ./userscripts/audio-convert_aiff-2-flac.nix {};
  user-audio-flac-2-flac = pkgs.callPackage ./userscripts/audio-convert_flac-2-flac.nix {};
  user-audio-wav-2-flac = pkgs.callPackage ./userscripts/audio-convert_wav-2-flac.nix {};
  user-audio-reencodeLossless =
    pkgs.callPackage ./userscripts/audio-reencodeLossless.nix
    {
      inherit
        user-audio-aiff-2-flac
        user-audio-flac-2-flac
        user-audio-wav-2-flac
        ;
    };
  user-audio-reencodeLossy =
    pkgs.callPackage ./userscripts/audio-reencodeLossy.nix
    {
      inherit
        user-audio-flac-2-opus
        user-audio-m4a-2-opus
        user-audio-mp3-2-opus
        user-audio-ogg-2-opus
        ;
    };
  user-audio-syncDAC = pkgs.callPackage ./userscripts/audio-syncDAC.nix {};
  user-audio-playlist-2-android = pkgs.callPackage ./userscripts/audio-playlist-2-android.nix {};

  # System related scripts
  user-script-vifm-visualpreview = pkgs.callPackage ./userscripts/vifm-visualpreview.nix {};
  user-script-vifm-preview = pkgs.callPackage ./userscripts/vifm-preview.nix {};
}
