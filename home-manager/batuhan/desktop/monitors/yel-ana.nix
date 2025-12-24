# home-manager/batuhan/desktop/monitors/yel-ana.nix
# Kanshi; monitor hotswap for yel-ana
{...}: {
  services.kanshi = {
    settings = [
      # MONITORS
      {
        # The laptop internal monitor
        output = {
          criteria = "BOE 0x0BCA Unknown";
          alias = "yel-ana_internal";
          mode = "2256x1504@60.00Hz";
          position = "0,0";
          scale = 1.0;
        };
      }
      {
        # The left uncurved monitor
        output = {
          criteria = "Dell Inc. DELL U2723QE 945Q834";
          alias = "yertengri_flat";
          mode = "3840x2160@60.00Hz";
          position = "2256,0";
          scale = 1.0;
        };
      }
      {
        # The right uncurved monitor
        output = {
          criteria = "Dell Inc. DELL U3425WE B8KFV84";
          alias = "yertengri_curved";
          mode = "3440x1440@59.97Hz";
          position = "2256,0";
          scale = 1.0;
        };
      }
      # PROFILES
      {
        profile = {
          name = "yel-ana_default";
          outputs = [
            {
              criteria = "$yel-ana_internal";
              status = "enable";
            }
          ];
        };
      }
      {
        profile = {
          name = "yel-ana_home-left";
          outputs = [
            {
              criteria = "$yel-ana_internal";
              status = "disable";
            }
            {
              criteria = "$yertengri_flat";
              status = "enable";
            }
          ];
        };
      }
      {
        profile = {
          name = "yel-ana_home-right";
          outputs = [
            {
              criteria = "$yel-ana_internal";
              status = "disable";
            }
            {
              criteria = "$yertengri_curved";
              status = "enable";
            }
          ];
        };
      }
    ];
  };
}
