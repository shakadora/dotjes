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
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Enable the Niri Wayland Compositor Module natively
  programs.niri.enable = true;

  # Enable and Configure Zsh System-wide
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # System-wide Kitty Configuration with Gruvbox Dark Theme
  programs.kitty = {
    enable = true;
    extraConfig = ''
      # Gruvbox Dark Color Scheme
      background #282828
      foreground #ebdbb2
      selection_background #ebdbb2
      selection_foreground #282828
      url_color #83a598

      # Colors
      color0 #282828
      color8 #928374
      color1 #cc241d
      color9 #fb4934
      color2  #98971a
      color10 #b8bb26
      color3  #d79921
      color11 #fabd2f
      color4  #458588
      color12 #83a598
      color5  #b16286
      color13 #d3869b
      color6  #689d6a
      color14 #8ec07c
      color7  #a89984
      color15 #fbf1c7
    '';
  };

  # Basic Desktop Hardware Integration
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Session Polkit Agent (Handles root privilege prompts for graphical apps)
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "gnome-polkit-authentication-agent";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

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
    extraGroups = [ "networkmanager" "wheel" "video" ]; # wheel grants sudo access
  };

  # Allow proprietary software (Required for Steam, Stremio, and Pyright)
  nixpkgs.config.allowUnfree = true;

  # =========================================================================
  # 2. HARDWARE & GAMING CONFIGURATION
  # =========================================================================

  # AMD CPU Optimizations & Performance Governor
  boot.kernelParams = [ "amd_pstate=active" ];
  powerManagement.cpuFreqGovernor = "performance";

  # AMD GPU Drivers & Vulkan Support
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Crucial for 32-bit Steam titles
  };

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

  # OpenRGB System Daemon
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
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

    # Everyday Applications & Media
    firefox              # Default web browser
    vlc                  # Versatile media player
    stremio              # Media streaming application
    yazi                 # Fast, asynchronous terminal file manager
    yt-dlp               # Command-line video downloader

    # Reading & Comics (.epub, .pdf, .cbr, .cbz)
    foliate              # Beautiful, modern GTK ebook viewer
    yacreader            # Comic book cataloger and frame reader
    zathura              # Minimalist terminal document runner
    zathura-cb           # Comic backend extension plugin for Zathura

    # Gaming & System Tuning
    kitty                # Fast Wayland terminal emulator
    protonup-qt          # Automated installer for Proton-GE tools
    mangohud             # Real-time HUD stats engine for games
    openrgb              # User control software interface for RGB boards
    btop                 # Modern, beautiful visual system monitor

    # Base Dependencies for LazyVim Configurations
    git
    gnumake
    gcc
    ripgrep
    fd
    unzip
    wget

    # Software Engineering Tools & LSPs
    nixd                 # High-efficiency language server for Nix expressions
    lua-language-server
    pyright
    black
  ];

  # The stable release snapshot identifier for tracking system migrations
  system.stateVersion = "26.05";
}
