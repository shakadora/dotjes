{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # System Base
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos-gaming";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # Display & Desktop
  services.displayManager.sddm = { enable = true; wayland.enable = true; };
  programs.niri.enable = true;
  # services.xserver.windowManager.qtile.enable = true; # Qtile option

  # Shell & User
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake .#nixos-gaming";
      cd = "z";
      ls = "eza --icons --git --heading";
    };
  };
  users.users.yourusername = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "gamemode" ];
  };

  # Audio, Hardware, Drivers
  security.rtkit.enable = true;
  services.pipewire = { enable = true; alsa.enable = true; pulse.enable = true; };
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Gaming & AMD Tweaks
  boot.kernelParams = [ "amd_pstate=active" ];
  powerManagement.cpuFreqGovernor = "performance";
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = { enable = true; enable32Bit = true; };
  programs.gamemode.enable = true;
  programs.steam = { enable = true; remotePlay.openFirewall = true; };

  # Environment
  programs.neovim = { enable = true; defaultEditor = true; };
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  system.stateVersion = "26.05";
}
