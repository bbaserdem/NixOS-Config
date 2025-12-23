# home-manager/batuhan/desktop/kanshi/profiles.nix
# Kanshi; profile definitions for monitor configurations
{...}: {
  services.kanshi.profiles = {
    yel-ana-default = {
      name = "Yel Ana: Default";
      outputs = [
        {
          criteria = "$yel-ana_internal";
          position = "0,0";
          scale = 1;
        }
      ];
    };
    yel-ana-homeLeft = {
      name = "Yel Ana: Home (Left)";
      outputs = [
        {
          criteria = "$yel-ana_internal";
          status = "disable";
        }
        {
          criteria = "$yertengri_flat";
          position = "0,0";
          scale = 1;
        }
      ];
    };
    yel-ana-homeRight = {
      name = "Yel Ana: Home (Right)";
      outputs = [
        {
          criteria = "$yel-ana_internal";
          status = "disable";
        }
        {
          criteria = "$yertengri_curved";
          position = "0,0";
          scale = 1;
        }
      ];
    };
    yertengri-default = {
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
          scale = 1;
        }
      ];
    };
  };
}
