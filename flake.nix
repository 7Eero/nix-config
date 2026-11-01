{
  description = "Modular NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      flake = false;
    };
    dms-cli = {
      url = "github:AvengeMedia/danklinux";
      flake = false;
    };
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
    };
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, niri, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in rec {
      nixosConfigurations = {
        "nixos-btw" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nixos-btw/system/configuration.nix
            niri.nixosModules.niri
          ];
        };

        "nixos" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nixos/system/configuration.nix
            niri.nixosModules.niri
          ];
        };
      };

      homeConfigurations = {
        "eero@archlinux" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/arch/default.nix
            niri.homeModules.niri
          ];
          extraSpecialArgs = { inherit inputs; };
        };

        "eero" = homeConfigurations."eero@archlinux";

        "eero@nixos-btw" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/nixos-btw/default.nix
            niri.homeModules.niri
          ];
          extraSpecialArgs = { inherit inputs; };
        };

        "eero@nixos" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/nixos/default.nix
            niri.homeModules.niri
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}