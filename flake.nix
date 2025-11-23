{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    # Import the system helper function with required inputs.
    mkSystem = import ./lib/mksystem.nix {
      inherit inputs nixpkgs nixpkgs-unstable;
    };
  in {
    nixosConfigurations = {
      server = mkSystem "server" {
        system = "x86_64-linux";
      };
      desktop = mkSystem "desktop" {
        system = "x86_64-linux";
      };
      blaidd-wsl = mkSystem "blaidd-wsl" {
        system = "x86_64-linux";
        wsl = true;
      };
    };
  };
}
