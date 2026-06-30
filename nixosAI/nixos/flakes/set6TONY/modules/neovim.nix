{ config, pkgs, ... }:

{
  # Standalone Neovim package suite and its essential tooling dependencies
  home.packages = with pkgs; [
    # Core Editor & TreeSitter/Lazy Compilation Tools
    git
    gnumake
    gcc
    unzip
    wget
    
    # Search & Navigation Utilities
    ripgrep
    fd
    fzf

    # Software Engineering Tools & LSPs
    nixd                 # High-efficiency language server for Nix expressions
    lua-language-server
    pyright
    black
  ];

  # System-wide Neovim Default Handler Configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
