# NNN config
{
  config,
  pkgs,
  ...
}: {
  programs.nnn = {
    enable = true;
    package = pkgs.nnn;
    bookmarks = {
      M = "${config.home.homeDirectory}/Media";
      m = "/home/data";
    };
    plugins = {
      src = "${pkgs.nnn}/share/plugins";
      mappings = {
        n = "autojump";
        d = "bulknew";
        c = "chksum";
        D = "diffs";
        f = "finder";
        F = "fzcd";
        o = "fzopen";
        "+" = "fzplug";
        R = "gitroot";
        e = "gpge";
        v = "imgview";
        " " = "launch";
        i = "ipinfo";
        t = "mimelist";
        M = "mtpmount";
        m = "nmount";
        p = "preview-tui";
        k = "pskill";
        r = "renamer";
        y = "rsynccp";
        s = "splitjoin";
        S = "suedit";
        x = "togglex";
        u = "umounttree";
      };
    };
  };
  # Config options from environment
  home.sessionVariables = {
    NNN_OPTS = "adD";
    NNN_COLORS = "6423";
    NNN_TMPFILE = "/tmp/.lastd";
  };
}
