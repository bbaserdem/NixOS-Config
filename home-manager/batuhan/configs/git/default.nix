# Configuring git 
{
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "bbaserdem";
    userEmail = "baserdemb@gmail.com";
    aliases = {
      pu = "push";
      co = "checkout";
      cm = "commit";
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };
      pull = {
        rebase = false;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
