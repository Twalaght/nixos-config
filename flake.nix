{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
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
        preferUnstable = false;
      };
      desktop = mkSystem "desktop" {
        system = "x86_64-linux";
        preferUnstable = true;
      };
    };
  };
}
