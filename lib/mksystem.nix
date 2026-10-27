# Create a NixOS/Darwin/WSL system with standardised config.
{
  self,
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  nix-darwin,
  nixos-wsl,
}: systemName: {
  system,
  darwin ? false,
  wsl ? false,
}: let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  systemFunc =
    if darwin
    then nix-darwin.lib.darwinSystem
    else nixpkgs.lib.nixosSystem;

  systemType =
    if darwin
    then "darwin"
    else if wsl
    then "wsl"
    else "nixos";
in
  systemFunc rec {
    specialArgs =
      inputs
      // {
        inherit self;
        inherit inputs;
        inherit pkgs-unstable;
        inherit systemType; # Must be known before import time.
      };

    modules = [
      # If building a WSL machine, include the relevant import.
      (
        if wsl
        then nixos-wsl.nixosModules.wsl
        else {}
      )

      {nixpkgs.pkgs = pkgs;}
      ../hosts/${systemType}/${systemName}/default.nix

      # Expose the system info and personal library for usage within modules.
      ({
        config,
        pkgs,
        ...
      }: {
        _module.args = {
          inherit systemName;
          systemVars = config.vars.${systemName};
          myLib = import ./helpers.nix {inherit (pkgs) lib;};
        };

        # Set Git commit hash for the system's version.
        system.configurationRevision = self.rev or self.dirtyRev or null;
      })
    ];
  }
