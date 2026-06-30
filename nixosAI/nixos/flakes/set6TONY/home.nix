{ config, pkgs, ... }:

{
  # Import modular configurations from subdirectories
  imports = [
    ./modules/neovim.nix
  ];

  home.username = "yourusername"; # CHANGE 'yourusername'
  home.homeDirectory = "/home/yourusername";

  # User-facing applications (minus isolated neovim dependencies)
  home.packages = with pkgs; [
    # Shell, UI & Basics
    noctalia-shell
    waybar
    mako
    swaylock-effects
    polkit_gnome
    xwayland-satellite
    xdg-utils
    kitty
    tmux

    # Gaming & System Monitoring
    mangohud
    protonup-qt
    heroic
    lutris
    openrgb
    btop
    pavucontrol
    playerctl

    # Productivity & Media Viewers
    firefox
    libreoffice-fresh
    kdePackages.kate
    vlc
    mpv
    stremio-linux-shell
    
    # CLI Utilities
    zoxide
    eza
    lazygit
    bat
    fzf
    trash-cli
    nix-index
    cava
    fastfetch
    yazi
    grim
    slurp
    swappy
    zathura
    imv
  ];

  # Niri Shell Initialization
  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "noctalia"
  '';

  programs.git.enable = true;
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
}
