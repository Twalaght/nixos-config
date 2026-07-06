# Create a NixOS/Darwin/WSL system with standardised config.
{
  self,
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  nix-darwin,
  nixos-wsl,
}: name: {
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
      };

    modules = [
      # If building a WSL machine, include the relevant import.
      (
        if wsl
        then nixos-wsl.nixosModules.wsl
        else {}
      )

      {nixpkgs.pkgs = pkgs;}
      ../hosts/${systemType}/${name}/default.nix

      # Expose the Darwin and WSL variables for usage within modules.
      {
        config._module.args = {
          inherit name;
          isDarwin = darwin;
          isWsl = wsl;
        };
      }
    ];
  }
