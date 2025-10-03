# Su-İyesi: MacOS config
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  config,
  pkgs,
  host,
  arch,
  ...
}: let
  username = "batuhan";
in {
  # You can import other modules here
  imports = [
    inputs.mac-app-util.darwinModules.default
    inputs.sops-nix.darwinModules.sops
    inputs.home-manager.darwinModules.home-manager
    inputs.stylix.darwinModules.stylix
    # Own modules
    ./desktop.nix
    # Pick and select modules
    ../../bundles/nix.nix
  ];

  # Trying to make stylix work, this is pain
  stylix.image = ./wallpaper.jpg;

  # Nixpkgs options
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    hostPlatform = "aarch64-darwin";
    overlays = [
      # My overlays
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # NUR overlay
      inputs.nur.overlays.default
    ];
  };

  # Set our name
  networking = {
    computerName = "Su Ana: Batuhan's MBP";
    hostName = "su-ana";
  };

  # Set our user
  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
    isHidden = false;
    shell = pkgs.zsh;
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs host arch;
      user = "batuhan";
    };
    users.${username} = import ../../../home-manager/batuhan/su-ana.nix;
  };

  # Homebrew
  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      # AI tools
      "claude"
      "cursor"
      "repo-prompt"

      # Comms
      "slack"
      "google-drive"

      # Programming
      "iterm2"
      "github"
      "bitwarden"

      # Utility Tools
      "qgis"
      "obsidian"
      "appcleaner"
      "karabiner-elements"
      "foobar2000"
    ];
    masApps = {};
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };

  # Secrets management
  sops.secrets = {
    "syncthing/key" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      owner = username;
    };
    "syncthing/cert" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      owner = username;
    };
  };

  # Add brew to shell environment

  # Fonts to install
  fonts.packages = with pkgs; [
    unstable.nerd-fonts.symbols-only
    noto-fonts-monochrome-emoji # Emoji fonts
    noto-fonts-color-emoji
    _3270font # Monospace
    fira-code # Monospace with ligatures
    liberation_ttf # Windows compat.
    caladea #   Office fonts alternative
    carlito #   Calibri/georgia alternative
    inconsolata # Monospace font, for prints
    iosevka # Monospace font, for terminal mostly
    jetbrains-mono # Readable monospace font
    noto-fonts
    source-serif-pro
    source-sans-pro
    curie # Bitmap fonts
    tamsyn
  ];

  # Programs
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    man.enable = true;
    nix-index.enable = true;
    zsh = {
      enable = true;
      #enableAutosuggestions = true;
      enableBashCompletion = true;
      enableCompletion = true;
      #enableFastSyntaxHighlighting = true;
      enableFzfCompletion = true;
      enableFzfGit = true;
      enableGlobalCompInit = true;
      enableFzfHistory = true;
      enableSyntaxHighlighting = true;
    };
  };

  # System settings
  system = {
    # Turn off NIX_PATH warnings now that we're using flakes
    checks.verifyNixPath = false;
    primaryUser = username;
    stateVersion = 6;
    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };
      dock = {
        autohide = true;
        autohide-delay = 0.1;
        largesize = 32;
        launchanim = true;
        minimize-to-application = true;
        mouse-over-hilite-stack = true;
        orientation = "left";
        show-recents = false;
        showhidden = true;
        tilesize = 48;
        # Hot corner actions
        wvous-tr-corner = 1; # Nothing
        wvous-tl-corner = 2; # Mission control
        wvous-bl-corner = 3; # Application Windows
        wvous-br-corner = 12; # Notification Center
      };
      finder = {
        _FXShowPosixPathInTitle = false;
      };
      loginwindow = {
        DisableConsoleAccess = false;
        GuestEnabled = false;
      };
      iCal = {
        CalendarSidebarShown = true;
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
      menuExtraClock = {
        Show24Hour = true;
      };
      screencapture = {
        # location = "";
        type = "png";
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
