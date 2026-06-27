{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # =========================================================================
  # 1. SYSTEM BASE CONFIGURATION (Required for Installation)
  # =========================================================================

  # Enable Flakes and the modern Nix CLI Tooling natively
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader settings (Standard UEFI setup)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos-gaming";
  networking.networkmanager.enable = true;

  # Time zone and Internationalization
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system backend infrastructure
  services.xserver.enable = true;

  # Display Manager (GDM handles Niri Wayland sessions cleanly)
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;

  # Enable the Niri Wayland Compositor Module natively
  programs.niri.enable = true;

  # Enable and Configure Zsh System-wide
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      cd = "z";   # Overrides standard cd to use zoxide's smart jumping database
      ls = "eza --icons --git --heading"; # Overrides standard ls to use eza with icons
    };
  };

  # Basic Desktop Hardware Integration
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Network Discovery (Crucial for Wireless/Network Printing detection)
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Modern mDNS resolution for IPv4 network layouts
    # nssmdns6 = true; # Uncomment this if you require IPv6 local host resolution
    openFirewall = true;
  };

  # Enable CUPS Printing System and Samsung Hardware Drivers
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      samsung-unified-linux-driver
      splix
    ];
  };

  # Session Polkit Agent (Handles root privilege prompts for graphical apps)
 ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";

  # Enable High-Fidelity Audio via PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define primary user account
  users.users.yourusername = { # CHANGE 'yourusername' to your preferred login name
    isNormalUser = true;
    description = "Primary User";
    shell = pkgs.zsh; # Set Zsh as your default interactive login shell
    extraGroups = [ "networkmanager" "wheel" "video" "lp" "scanner" "gamemode" ];
  };

  # Allow proprietary software (Required for Steam, Drivers, Stremio, and Pyright)
  nixpkgs.config.allowUnfree = true;

  # =========================================================================
  # 2. HARDWARE & GAMING CONFIGURATION
  # =========================================================================

  # AMD CPU Optimizations & Performance Governor
  boot.kernelParams = [ "amd_pstate=active" ];
  powerManagement.cpuFreqGovernor = "performance";

  # AMD GPU Drivers, Vulkan, & Hardware Video Acceleration Support
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Crucial for 32-bit Steam titles
    extraPackages = with pkgs; [
      libva-utils       # Verifies VA-API decoding via command line
      rocm-opencl-icd   # Optional: Adds compute acceleration for your AMD card
    ];
  };

  # Enables kernel-level driver permissions for Steam controllers (PS/Xbox/Switch)
  hardware.steam-hardware.enable = true;


  # Feral GameMode Optimization System Natively
  programs.gamemode.enable = true;

  # Steam Native Module Configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Gamescope Environment Integrations
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # OpenRGB System Daemon Infrastructure
    boot.kernelModules = [ "i2c-dev" ];
    hardware.i2c.enable = true;
    services.hardware.openrgb.enable = true;

  };

  # Automatic OpenRGB Profile Loader on User Login
  systemd.user.services.openrgb-autostart = {
    description = "Load default OpenRGB profile on login";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.openrgb}/bin/openrgb --profile default.orp";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # Global MangoHud Configuration Override
  environment.etc."MangoHud/MangoHud.conf".text = ''
    toggle_hud=Shift_L+m
  '';

  # System-wide Neovim Default Handler
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Font Selection for LazyVim Glyphs and Icons
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts-emoji             # Ensures system-wide text emojis render natively
    corefonts                    # Optional: Injects standard MS fonts for LibreOffice layout rendering
  ];

  # =========================================================================
  # 3. ENVIRONMENT & PACKAGES
  # =========================================================================
  environment.systemPackages = with pkgs; [
    # Wayland Modular Desktop Plumbing (Substitutes for a full DE environment)
    waybar               # Top panel status bar
    mako                 # Standalone notification daemon
    swaylock-effects     # Screen locker utility
    fuzzel               # Keyboard-driven app runner and launcher
    polkit_gnome         # UI window helper for privilege elevations
    xwayland-satellite   # Runs legacy X11 binary software windows seamlessly
    xdg-utils            # Explicit file management and browser call handler hooks

    # Everyday Applications, Media & Productivity
    firefox              # Default web browser
    libreoffice-fresh    # Modern open-source productivity suite
    kdePackages.kate     # Advanced graphical text editor with built-in LSP engine
    vlc                  # Versatile media player
    mpv                  # Crucial high-performance video backend runner for TUIs
    stremio-linux-shell  # Media streaming application
    yazi                 # Fast, asynchronous terminal file manager
    yt-dlp               # Command-line video downloader

    # Keyboard-Driven TUI Media Utilities
    ytfzf                # FZF terminal YouTube search interface + thumbnail engine
    yewtube              # Native TUI music player and audio streamer backend

    # Reading, Comics & Image Viewers
    foliate              # Beautiful, modern GTK ebook viewer
    yacreader            # Comic book cataloger and frame reader
    zathura              # Minimalist terminal document runner (and native PDF reader)
    imv                  # Keyboard-driven, fast image viewer tailored for Wayland
    loupe                # Elegant, hardware-accelerated GTK4 photo/GIF viewer
    nsxiv                # Neo Simple X Image Viewer with fast thumbnail indexing

    # Utilities, Fun, & Configuration Dev TUIs
    kitty                # Terminal emulator
    tmux                 # Professional workspace terminal pane multiplexer
    grim                 # Screen capture utility for Wayland
    slurp                # Region selection tool for Wayland
    swappy               # Wayland snapshot editor and annotation tool
    zoxide               # Smarter 'cd' command that learns your favorite config paths
    eza                  # Modern replacement for 'ls' with native Git tracking status
    lazygit              # Interactive terminal UI layout wrapper for Git tasks
    bat                  # Color-highlighted alternative to native text view pipelines
    fzf                  # Dedicated standalone fuzzy command line search helper
    trash-cli            # Safe path CLI replacement wrapper protecting file deletions
    nix-index            # Command missing lookup tool and database scanner
    cava                 # Console-based Audio Visualizer for ALSA/PipeWire
    cmatrix              # Classic digital terminal matrix rain screensaver
    fastfetch            # Ultra-fast, modern system information fetching utility
    lolcat               # Rainbow colorizer wrapper for terminal text outputs
    pipes-rs             # Animated pipe screensaver (blazing fast Rust variant)
    cbonsai              # Live terminal bonsai tree growth generator
    asciiquarium         # Retro ASCII animated aquarium simulator
    cowsay               # Classic configurable ASCII conversational cow utility
    fortune              # Random witty quotation and adage data pipeline
    peaclock             # Advanced custom block-matrix TUI clock and timer
    # nixmate            # Commented out for initial base OS install pass

    # Gaming & System Tuning
    heroic               # Open-source Epic, Amazon, and GOG software engine launcher
    lutris               # Unified tracking interface hub for alternative runner libraries
    protonup-qt          # Automated installer for Proton-GE tools
    mangohud             # Real-time HUD stats engine for games
    openrgb              # User control software interface for RGB boards
    btop                 # Modern, beautiful visual system monitor
    pavucontrol          # PulseAudio/PipeWire Graphical Volume Device Route Control Panel
    playerctl            # CLI hardware media tracking control tool (for music keys mappings)


    # Base Dependencies for LazyVim Configurations
    git
    gnumake
    gcc
    ripgrep
    fd
    unzip
    wget

    # Software Engineering Tools & LSPs (Shared across Neovim and Kate)
    nixd                 # High-efficiency language server for Nix expressions
    lua-language-server
    pyright
    black
  ];

  # The stable release snapshot identifier for tracking system migrations
  system.stateVersion = "26.05";
}
