{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # --- System Core ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos-gaming";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Desktop & Shell ---
  services.displayManager.sddm = { enable = true; wayland.enable = true; };
  programs.niri.enable = true;
  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake .#nixos-gaming";
      ls = "eza --icons";
    };
  };

  # --- Hardware & Audio ---
  hardware.bluetooth.enable = true;
  services.pipewire = { enable = true; alsa.enable = true; pulse.enable = true; };
  security.rtkit.enable = true;

  # --- Gaming & AMD Setup ---
  nixpkgs.config.allowUnfree = true;
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.graphics.enable = true;
  programs.gamemode.enable = true;
  programs.steam.enable = true;

  users.users.yourusername = { # CHANGE ME
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
  };

  system.stateVersion = "26.05";
}
