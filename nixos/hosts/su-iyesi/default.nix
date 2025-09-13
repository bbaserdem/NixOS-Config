# Su-İyesi: MacOS config
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  config,
  pkgs,
  host,
  ...
}: let
  username = "batuhan";
in {
  # You can import other modules here
  imports = [
    inputs.sops-nix.darwinModules.sops
    inputs.home-manager.darwinModules.home-manager
    inputs.stylix.darwinModules.stylix
  ];

  # Nixpkgs options
  nixpkgs = {
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
    computerName = "Su İyesi: Batuhan's MBP";
    hostName = "su-iyesi";
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
      inherit inputs outputs host;
      user = "batuhan";
    };
    users.${username} = import ../../../home-manager/batuhan/su-iyesi.nix;
  };

  # Homebrew
  homebrew = {
    enable = true;
    casks = import ./casks.nix;
  };

  # Secrets management
  sops.secrets = {
    "syncthing/key" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      owner = username;
      group = config.users.users.nobody.group;
    };
    "syncthing/cert" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      owner = username;
      group = config.users.users.nobody.group;
    };
  };

  # Setup nix
  nix = {
    # We don't want to use determinate nix cause hostname issues
    enable = true;
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      trusted-users = [
        "@admin"
        "${username}"
      ];
    };
    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

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
        autohide-delay = 3.0;
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
