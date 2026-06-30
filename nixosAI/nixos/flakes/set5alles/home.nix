{ config, pkgs, ... }:

{
  home.username = "yourusername"; # CHANGE 'yourusername'
  home.homeDirectory = "/home/yourusername";

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

    # Gaming & Monitoring
    mangohud 
    protonup-qt 
    heroic  
    lutris 
    openrgb 
    btop 
    pavucontrol 
    playerctl

    # Productivity & Media
    firefox 
    libreoffice-fresh 
    kdePackages.kate 
    vlc 
    mpv 
    stremio-linux-shell
    
    # CLI Tools & Viewers
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

  # Niri Startup
  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "noctalia"
  '';

  programs.git.enable = true;
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
}
