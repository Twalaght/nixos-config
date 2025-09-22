# Create a NixOS system with standard defaults.
args @ {
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  ...
}: name: {system}: let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  # Build dynamically from any additional arguments explicitly provided.
  additionalArguments = builtins.removeAttrs args ["nixpkgs" "nixpkgs-unstable" "name" "system"];
in
  nixpkgs.lib.nixosSystem rec {
    specialArgs =
      {
        inherit inputs pkgs-unstable;
      }
      // additionalArguments;

    modules = [
      {nixpkgs.pkgs = pkgs;}
      ../hosts/nixos/${name}/default.nix
    ];
  }
