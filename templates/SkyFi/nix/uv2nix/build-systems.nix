# Build system overrides for problematic packages
{
  pkgs,
  lib,
  ...
}: let
  # Build system dependencies for problematic packages
  buildSystemOverrides = {
    gdal = {
      setuptools = [];
      wheel = [];
      numpy = [];
    };
    pygraphviz = {
      setuptools = [];
      wheel = [];
    };
    numpy = {
      meson-python = [];
      cython = [];
    };
    numba = {
      setuptools = [];
      wheel = [];
    };
  };
in {
  inherit buildSystemOverrides;

  # Create build system override packages
  mkBuildSystemOverrides = final: prev:
    lib.mapAttrs (
      name: spec:
        if prev ? ${name}
        then
          prev.${name}.overrideAttrs (old: {
            nativeBuildInputs =
              old.nativeBuildInputs
              ++ final.resolveBuildSystem spec
              ++ lib.optionals (name == "gdal") [
                pkgs.gdal
                pkgs.proj
                pkgs.geos
                pkgs.pkg-config
              ]
              ++ lib.optionals (name == "pygraphviz") [
                pkgs.graphviz
                pkgs.pkg-config
              ]
              ++ lib.optionals (name == "numba") [
                pkgs.tbb_2021_11
              ]
              ++ lib.optionals (name == "numpy") [
                pkgs.ninja
                pkgs.meson
                pkgs.pkg-config
              ];
            
            # Add GDAL-specific environment variables
            buildInputs = old.buildInputs or [] ++ lib.optionals (name == "gdal") [
              pkgs.gdal
            ];
            
            # Set environment variables for GDAL build
            GDAL_HOME = lib.optionalString (name == "gdal") "${pkgs.gdal}";
            GDAL_DATA = lib.optionalString (name == "gdal") "${pkgs.gdal}/share/gdal";
            PROJ_LIB = lib.optionalString (name == "gdal") "${pkgs.proj}/share/proj";
          })
        else null
    )
    buildSystemOverrides;
}
