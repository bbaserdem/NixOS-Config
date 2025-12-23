# home-manager/batuhan/desktop/kanshi/monitors.nix
# Kanshi; list of all the monitors to be used
{...}: {
  imports = [
    ./monitors.nix
  ];

  services.kanshi.settings = [
    {
      # The laptop internal monitor
      output = {
        criteria = "BOE 0x0BCA Unknown";
        alias = "yel-ana_internal";
        mode = "2256x1504@60.00Hz";
      };
    }
    {
      # The left uncurved monitor
      output = {
        criteria = "Dell Inc. Dell U2723QE 945Q834";
        alias = "yertengri_flat";
        mode = "3840x2160@60.00Hz";
      };
    }
    {
      # The right uncurved monitor
      output = {
        criteria = "Dell Inc. Dell U3425WE B8KFV84";
        alias = "yertengri_curved";
        mode = "3440x1440@59.97Hz";
      };
    }
  ];
}
