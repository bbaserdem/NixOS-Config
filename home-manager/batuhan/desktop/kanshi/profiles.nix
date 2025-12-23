# home-manager/batuhan/desktop/kanshi/monitors.nix
# Kanshi; list of all the monitors to be used
{...}: {
  imports = [
    ./monitors.nix
  ];

  services.kanshi.profiles = {
    yel-ana-default = {
      name = "Yel Ana: Default";
      outputs = [
        {
          alias = "yel-ana_internal";
          position = "0,0";
          scale = 1;
        }
      ];
    };
    yel-ana-homeLeft = {
      name = "Yel Ana: Home (Left)";
      outputs = [
        {
          alias = "yel-ana_internal";
          status = "disable";
        }
        {
          alias = "yertengri_flat";
          position = "0,0";
          scale = 1;
        }
      ];
    };
    yel-ana-homeRight = {
      name = "Yel Ana: Home (Right)";
      outputs = [
        {
          alias = "yel-ana_internal";
          status = "disable";
        }
        {
          alias = "yertengri_curved";
          position = "0,0";
          scale = 1;
        }
      ];
    };
    yertengri-default = {
      name = "Yertengri: Default";
      outputs = [
        {
          alias = "yertengri_flat";
          position = "0,0";
          scale = 1.5;
        }
        {
          alias = "yertengri_curved";
          position = "3840,0";
          scale = 1;
        }
      ];
    };
  };
}
