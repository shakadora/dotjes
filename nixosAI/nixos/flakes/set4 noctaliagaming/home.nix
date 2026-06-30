{ config, pkgs, ... }:

{
  home.username = "myuser";
  home.homeDirectory = "/home/myuser";

  home.packages = with pkgs; [
    firefox
    neovim
    htop
    kitty
    
    # The Visual Desktop Components
    noctalia-shell  # Modern Wayland UI Shell (Bar, Launchers, Lockscreen)
    
    # Gaming Companion Tools
    mangohud        # Customizable telemetry overlay (FPS, Frame timings, Temps)
    protonup-qt     # Easily download Proton-GE layers directly for Steam
  ];

  # =========================================================================
  # NIRI COMPOSITOR INITIALIZATION
  # =========================================================================
  # Instructs Niri to launch the Noctalia shell ecosystem immediately upon loading
  # Custom Niri configuration properties mapping to KDL format
  # Alternatively, write this straight to ~/.config/niri/config.kdl
  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "noctalia"

    // Bind your terminal shortcut
    binds {
        Mod+Return { spawn "kitty"; }
    }
  '';
  # =========================================================================

  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
}
