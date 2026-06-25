{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # =========================================================================
  # 1. SYSTEM BASE CONFIGURATION (Required for Installation)
  # =========================================================================

  # Bootloader settings (Standard UEFI setup)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos-gaming";
  networking.networkmanager.enable = true;

  # Time zone and Internationalization
  time.timeZone = "Europe/Brussels"; # Change to your timezone
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Desktop Environment (Example: KDE Plasma 6 - excellent for gaming/Wayland)
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable Sound with PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define your primary user account
  users.users.yourusername = { # CHANGE 'yourusername' to your preferred login name
    isNormalUser = true;
    description = "Primary User";
    extraGroups = [ "networkmanager" "wheel" ]; # wheel enables sudo
  };

  # Allow unfree packages (Required for Steam)
  nixpkgs.config.allowUnfree = true;

  # =========================================================================
  # 2. YOUR ORIGINAL HARDWARE & GAMING CONFIGURATION
  # =========================================================================

  # AMD CPU Optimizations & Performance Governor
  boot.kernelParams = [ "amd_pstate=active" ];
  powerManagement.cpuFreqGovernor = "performance";

  # AMD GPU Drivers & Vulkan Support
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Crucial for 32-bit Steam games
  };

  # Steam Configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;     # Opens ports for Steam Remote Play
    dedicatedServer.openFirewall = true; # Opens ports for Source Dedicated Servers
  };

  # Gamescope Configuration
  programs.gamescope = {
    enable = true;
    capSysNice = true; # Grants Gamescope process priority for smoother frame rates
  };

  # OpenRGB Service (Handles udev hardware rules and access permissions)
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd"; # Tells OpenRGB to explicitly search for AMD SMBus controllers
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

  # Global MangoHud Configuration (Sets Shift+M to toggle the HUD)
  environment.etc."MangoHud/MangoHud.conf".text = ''
    toggle_hud=Shift_L+m # Uses the Left Shift key
  '';

  # Enable Neovim System-wide
  programs.neovim = {
    enable = true;
    defaultEditor = true; # Makes Neovim your default terminal editor
    viAlias = true;
    vimAlias = true;
  };

  # Optimized Font Selection for LazyVim Icons
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # System-wide Packages
  environment.systemPackages = with pkgs; [
    # Gaming & RGB Tools
    protonup-qt  # Graphical tool to download custom Proton-GE versions
    mangohud     # Performance overlay for monitoring FPS, CPU, and GPU usage
    openrgb      # The OpenRGB GUI software interface

    # Core Dependencies for LazyVim
    git          # Required for LazyVim to clone plugins
    gnumake      # Compiler tools for high-performance plugins
    gcc          # C compiler required to build Tree-sitter syntax highlighting
    ripgrep      # Blazingly fast file text search for LazyVim's global search
    fd           # Fast file finder for finding files by name
    unzip        # Required for extraction of tools
    wget         # Network utility used for some plugin assets

    # Language Servers (LSPs)
    nixd                # High-performance language server for Nix code
    lua-language-server # The official Lua LSP for your Neovim configurations
    pyright             # Microsoft's production-ready Python language server
    black               # Standard Python code formatter for saving / cleanup
  ];

  # Do not change this value. It represents the NixOS release version
  # used to initialize your system state.
  system.stateVersion = "24.11";
}
