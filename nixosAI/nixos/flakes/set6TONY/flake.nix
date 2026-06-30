{
  description = "Modular Stable NixOS Flake with Niri, Noctalia, and AMD Gaming Tweaks";

  inputs = {
    # System package source pinned to stable release
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Home Manager source pinned to match system packages
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos-gaming = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix

        # Links home-manager as a module of the system flake
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.yourusername = import ./home.nix; # CHANGE 'yourusername'
        }
      ];
    };
  };
}
