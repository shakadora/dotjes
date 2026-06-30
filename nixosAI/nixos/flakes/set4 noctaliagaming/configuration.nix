{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking & Performance Hostname
  networking.hostName = "nixos-gaming";
  networking.networkmanager.enable = true;

  # Locale
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # =========================================================================
  # GAMING & HARDWARE OPTIMIZATIONS (Ryzen 9800X3D + Radeon 7800XT)
  # =========================================================================
  # Graphics Drivers & Execution Layers
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Crucial for 32-bit Steam games and Proton
    extraPackages = with pkgs; [
      amdvlk # Alternative Vulkan driver (useful to toggle per-game)
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # CPU Power Management Tuning for the 9800X3D vCache core structure
  powerManagement.cpuFreqGovernor = "performance";
  
  # Kernel Tweaks for Frametime Consistency & Reduced Stutter
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642; # Prevents crashes in heavy games (like Starfield/Cyberpunk)
    "kernel.split_lock_mitigate" = 0; # Disables split lock mitigation to recover gaming performance
  };

  # Enable Feral Gamemode (Optimizes CPU governors and nice values automatically)
  programs.gamemode.enable = true;

  # Enable Steam with optimized firewall mappings
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  # =========================================================================

  # =========================================================================
  # NOCTALIA BACKEND DAEMONS
  # =========================================================================
  # Enables Noctalia's bar to accurately process system variables
  services.power-profiles-daemon.enable = true; 
  services.upower.enable = true;
  hardware.bluetooth.enable = true;
  # =========================================================================

  # Display & Window Manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.niri.enable = true;

  # Commented-out Qtile option
  # services.xserver.enable = true;
  # services.xserver.windowManager.qtile.enable = true;

  nixpkgs.config.allowUnfree = true;

  users.users.myuser = {
    isNormalUser = true;
    description = "Gaming User";
    extraGroups = [ "networkmanager" "wheel" "video" "gamemode" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];

  system.stateVersion = "26.05";
}
