{ config, pkgs, ... }:

{
  home.username = "myuser";
  home.homeDirectory = "/home/myuser";

  # User-facing applications
  home.packages = with pkgs; [
    firefox
    neovim
    htop
    kitty     # Replaced alacritty with kitty
    fuzzel    # Recommended lightweight application launcher for Niri
  ];

  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
}
