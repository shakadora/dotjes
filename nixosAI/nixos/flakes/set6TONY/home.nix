{ config, pkgs, ... }:

let
  # Path to your active user dotfiles directory
  dotfiles = "${config.home.homeDirectory}/nixos-config/config";
  
  # Helper mapping function to generate out-of-store targets
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Define your custom application configuration folders here
  configs = {
    niri  = "niri";
    kitty = "kitty";
  };
in
{
  imports = [
    ./modules/neovim.nix
  ];

  home.username = "yourusername"; # CHANGE 'yourusername'
  home.homeDirectory = "/home/yourusername";

  # User-facing applications
  home.packages = with pkgs; [
    noctalia-shell waybar mako swaylock-effects polkit_gnome 
    xwayland-satellite xdg-utils kitty tmux
    mangohud protonup-qt heroic lutris openrgb btop pavucontrol playerctl
    firefox libreoffice-fresh kdePackages.kate vlc mpv stremio-linux-shell
    zoxide eza lazygit bat fzf trash-cli nix-index cava fastfetch yazi 
    grim slurp swappy zathura imv
  ];

  # Map the defined configurations recursively to ~/.config/
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  programs.git.enable = true;
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
}
