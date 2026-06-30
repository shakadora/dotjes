{ config, pkgs, ... }:

{
  home.username = "myuser";
  home.homeDirectory = "/home/myuser";

  # User-facing applications
  home.packages = with pkgs; [
    firefox
    neovim
    htop
    alacritty # Recommended default terminal for Niri
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
