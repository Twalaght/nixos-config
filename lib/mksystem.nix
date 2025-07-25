# Create a NixOS system with standard defaults, given a set of optional input paramaters.
{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
}: name: {
  system,
  preferUnstable ? false,
}: let
  # Conditionally swap the default package source with unstable,
  # if the associated flag was provided for the given system.
  baseNixpkgs =
    if preferUnstable
    then nixpkgs-unstable
    else nixpkgs;
  altNixpkgs =
    if preferUnstable
    then nixpkgs
    else nixpkgs-unstable;

  pkgs = import baseNixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  # TODO - This is badly named given the unstable flag. Will rename to `pkgs-alt`.
  pkgs-unstable = import altNixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
  nixpkgs.lib.nixosSystem rec {
    specialArgs = {
      inherit inputs;
      inherit pkgs-unstable;
    };

    modules = [
      ../hosts/nixos/${name}/default.nix
      # TODO - Naming convention could be improved to:
      # ../machines/${name}.nix;
    ];
  }
