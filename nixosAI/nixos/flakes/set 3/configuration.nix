{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time Zone and Locale
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # =========================================================================
  # AMD HARDWARE OPTIMIZATIONS (Ryzen 9800X3D + Radeon 7800XT)
  # =========================================================================
  # Enable AMD GPU Drivers
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Mesa Graphics Pipeline & Vulkan Support
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Critical for Steam/Proton performance
  };

  # CPU Governor Tuning for the 9800X3D
  powerManagement.cpuFreqGovernor = "performance";
  # =========================================================================

  # Display Manager & Window Managers
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true; # Ensures SDDM spawns natively in Wayland for Niri
  };

  # Enable the Niri scrollable tiling compositor
  programs.niri.enable = true;

  # Commented-out Qtile setup (uncomment to activate Qtile option)
  # services.xserver.enable = true;
  # services.xserver.windowManager.qtile.enable = true;

  # Allow unfree software (Required for Steam and proprietary AMD microcode)
  nixpkgs.config.allowUnfree = true;

  # Enable Steam with gaming optimizations
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Define basic user account shell and groups
  users.users.myuser = {
    isNormalUser = true;
    description = "My Name";
    extraGroups = [ "networkmanager" "wheel" "video" ]; 
  };

  # Core system-wide packages
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];

  system.stateVersion = "26.05"; # Match the true stable version target
}
