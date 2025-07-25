# NNN config
{
  config,
  pkgs,
  outputs,
  ...
}: let
  colors = config.colorScheme.palette;
in {
  # Install the package
  home.packages = [
    pkgs.vifm-full
    outputs.packages.${pkgs.system}.user-vifm
  ];
  # Configure the package
  xdg.configFile."vifm/vifmrc".source = ./vifmrc;
  xdg.configFile."vifm/colors/Default.vifm".text = ''
    highlight Win cterm=none ctermfg=white ctermbg=black
    highlight Directory cterm=bold ctermfg=cyan ctermbg=default
    highlight Link cterm=bold ctermfg=yellow ctermbg=default
    highlight BrokenLink cterm=bold ctermfg=red ctermbg=default
    highlight Socket cterm=bold ctermfg=magenta ctermbg=default
    highlight Device cterm=bold ctermfg=red ctermbg=default
    highlight Fifo cterm=bold ctermfg=cyan ctermbg=default
    highlight Executable cterm=bold ctermfg=green ctermbg=default
    highlight Selected cterm=bold ctermfg=magenta ctermbg=default
    highlight CurrLine cterm=bold,reverse ctermfg=default ctermbg=default
    highlight TopLine cterm=none ctermfg=black ctermbg=white
    highlight TopLineSel cterm=bold ctermfg=black ctermbg=default
    highlight StatusLine cterm=bold ctermfg=black ctermbg=white
    highlight WildMenu cterm=underline,reverse ctermfg=white ctermbg=black
    highlight CmdLine cterm=none ctermfg=white ctermbg=black
    highlight ErrorMsg cterm=none ctermfg=red ctermbg=black
    highlight Border cterm=none ctermfg=black ctermbg=white
    highlight JobLine cterm=bold,reverse ctermfg=black ctermbg=white
    highlight SuggestBox cterm=bold ctermfg=default ctermbg=default
    highlight CmpMismatch cterm=bold ctermfg=white ctermbg=red
    highlight AuxWin cterm=bold,underline,reverse,standout,italic ctermfg=default ctermbg=default
    highlight TabLine cterm=none ctermfg=white ctermbg=black
    highlight TabLineSel cterm=bold,reverse ctermfg=default ctermbg=default
    highlight User1 cterm=bold,underline,reverse,standout,italic ctermfg=default ctermbg=default
    highlight User2 cterm=bold,underline,reverse,standout,italic ctermfg=default ctermbg=default
    highlight User3 cterm=bold,underline,reverse,standout,italic ctermfg=default ctermbg=default
    highlight User4 cterm=bold,underline,reverse,standout,italic ctermfg=default ctermbg=default
    highlight User5 cterm=bold,underline,reverse,standout,italic ctermfg=default ctermbg=default
    highlight User6 cterm=bold,underline,reverse,standout,italic ctermfg=default ctermbg=default
    highlight User7 cterm=bold,underline,reverse,standout,italic ctermfg=default ctermbg=default
    highlight User8 cterm=bold,underline,reverse,standout,italic ctermfg=default ctermbg=default
    highlight User9 cterm=bold,underline,reverse,standout,italic ctermfg=default ctermbg=default
  '';
}
