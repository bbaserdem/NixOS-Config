# home-manager/batuhan/desktop/kanshi/default.nix
# Kanshi; monitor hotswap manager entry point
{...}: {
  services.kanshi = {
    enable = true;
    settings = [
      # MONITORS
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
      # PROFILES
      {
        profile = {
          name = "Yel Ana: Default";
          outputs = [
            {
              criteria = "$yel-ana_internal";
              position = "0,0";
              scale = 1.0;
            }
          ];
        };
      }
      {
        profile = {
          name = "Yel Ana: Home (Left)";
          outputs = [
            {
              criteria = "$yel-ana_internal";
              status = "disable";
            }
            {
              criteria = "$yertengri_flat";
              position = "0,0";
              scale = 1.0;
            }
          ];
        };
      }
      {
        profile = {
          name = "Yel Ana: Home (Right)";
          outputs = [
            {
              criteria = "$yel-ana_internal";
              status = "disable";
            }
            {
              criteria = "$yertengri_curved";
              position = "0,0";
              scale = 1.0;
            }
          ];
        };
      }
      {
        profile = {
          name = "Yertengri: Default";
          outputs = [
            {
              criteria = "$yertengri_flat";
              position = "0,0";
              scale = 1.5;
            }
            {
              criteria = "$yertengri_curved";
              position = "3840,0";
              scale = 1.0;
            }
          ];
        };
      }
    ];
  };
}
