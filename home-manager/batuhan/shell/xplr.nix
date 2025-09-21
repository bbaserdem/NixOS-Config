# NNN config
{
  config,
  pkgs,
  outputs,
  ...
}: {
  programs.xplr = {
    enable = true;
    plugins = with pkgs.xplrPlugins; (
      [
        tree-view-xplr
        tri-pane-xplr
      ]
      ++ (
        if pkgs.stdenv.platform.isLinux
        then [
          trash-cli-xplr
          wl-clibboard-xplr
        ]
        else []
      )
    );
    extraConfig = ''
      xplr.config.general.enable_mouse = true

      -- Safe plugin loading with pcall
      local function safe_require(plugin_name, config)
        local ok, plugin = pcall(require, plugin_name)
        if ok and plugin and plugin.setup then
          if config then
            plugin.setup(config)
          else
            plugin.setup()
          end
        end
      end

      -- Load plugins safely
      safe_require("dual-pane")
      safe_require("tree-view")
      safe_require("trash-cli")
      safe_require("wl-clipboard")
    '';
  };
}
