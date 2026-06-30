{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # =========================================================================
  # BTRFS STORAGE SYSTEM PREFERENCE OVERRIDES
  # =========================================================================
  # These combine with your auto-generated hardware file at compilation.
  # "zstd:3" yields optimal runtime speed-to-compression scaling for game assets.
  fileSystems."/" = {
    options = [ "subvol=@" "compress=zstd:3" "noatime" ];
  };

  fileSystems."/home" = {
    options = [ "subvol=@home" "compress=zstd:3" "noatime" ];
  };

  fileSystems."/nix" = {
    options = [ "subvol=@nix" "compress=zstd:3" "noatime" "nodatacow" ];
  };

  # Isolated Gaming Subvolume to protect backup storage allocations
  fileSystems."/home/yourusername/.local/share/Steam" = {
    options = [ "subvol=@games" "compress=zstd:3" "noatime" ];
  };

  # --- System Core ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos-gaming";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Desktop Display Environment & Shells ---
  services.displayManager.sddm = { 
    enable = true; 
    wayland.enable = true; 
  };
  programs.niri.enable = true; # Scrollable-tiling compositor target
  # services.xserver.windowManager.qtile.enable = true; # Commented-out Qtile option

  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake .#nixos-gaming";
      ls = "eza --icons";
    };
  };

  # --- Hardware Audio & Auxiliary Daemons ---
  hardware.bluetooth.enable = true;
  services.pipewire = { 
    enable = true; 
    alsa.enable = true; 
    pulse.enable = true; 
  };
  security.rtkit.enable = true;
  services.power-profiles-daemon.enable = true; # Noctalia hardware backend anchor

  # --- High-Performance AMD Gaming Matrix ---
  nixpkgs.config.allowUnfree = true;
  boot.kernelParams = [ "amd_pstate=active" ]; # Forces high-response Zen 4/5 frequency management
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = { 
    enable = true; 
    enable32Bit = true; # Required layer for Steam runtime engines
  };
  programs.gamemode.enable = true;
  programs.steam.enable = true;

  # --- User Profile Binding ---
  users.users.yourusername = { # CHANGE 'yourusername' to your target login name
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "video" "gamemode" ];
  };

  system.stateVersion = "26.05";
}
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
