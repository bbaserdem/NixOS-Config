# Python development shell
{
  pkgs,
  commonConfig,
  uvBoilerplate,
  ...
}: {
  packages = commonConfig.packages ++ (with pkgs; [
    uv
  ]) ++ uvBoilerplate.uvShellSet.packages;
  
  env = commonConfig.env // uvBoilerplate.uvShellSet.env;
  
  shellHook = commonConfig.shellHook + uvBoilerplate.uvShellSet.shellHook;
}