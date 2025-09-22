# Create a NixOS system with standard defaults.
{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  winapps,
}: name: {system}: let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
  nixpkgs.lib.nixosSystem rec {
    specialArgs = {
      inherit inputs;
      inherit pkgs-unstable;
	  inherit winapps;
    };

    modules = [
      {nixpkgs.pkgs = pkgs;}
      ../hosts/nixos/${name}/default.nix
    ];
  }
