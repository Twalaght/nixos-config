{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

	winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
	winapps,
    ...
  } @ inputs: let
    # Import the system helper function with required inputs.
    mkSystem = import ./lib/mksystem.nix {
      inherit inputs nixpkgs nixpkgs-unstable winapps;
    };
  in {
    nixosConfigurations = {
      server = mkSystem "server" {
        system = "x86_64-linux";
      };
      desktop = mkSystem "desktop" {
        system = "x86_64-linux";
      };
    };
  };
}
