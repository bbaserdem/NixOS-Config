# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs ? import <nixpkgs> {},
  ...
}: rec {
  # example = pkgs.callPackage ./example { };
  #suite2p = pkgs.callPackage ./suite2p {};
  user-audio = {
    to-opus     = pkgs.callPackage ./userscripts/audio-convert2opus.nix         {};
    flac-2-opus = pkgs.callPackage ./userscripts/audio-convert_flac-2-opus.nix  {};
    m4a-2-opus  = pkgs.callPackage ./userscripts/audio-convert_m4a-2-opus.nix   {};
    mp3-2-opus  = pkgs.callPackage ./userscripts/audio-convert_mp3-2-opus.nix   {};
    ogg-2-opus  = pkgs.callPackage ./userscripts/audio-convert_ogg-2-opus.nix   {};
    aiff-2-flac = pkgs.callPackage ./userscripts/audio-convert_aiff-2-flac.nix  {};
    flac-2-flac = pkgs.callPackage ./userscripts/audio-convert_flac-2-flac.nix  {};
    wav-2-flac  = pkgs.callPackage ./userscripts/audio-convert_wav-2-flac.nix   {};
    reencodeLossless  = pkgs.callPackage ./userscripts/audio-reencodeLossless.nix {};
    reencodeLossy     = pkgs.callPackage ./userscripts/audio-reencodeLossy.nix    {};
  };
}
