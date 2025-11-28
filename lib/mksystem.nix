# Create a NixOS/Darwin/WSL system with standardised config.
{
  self,
  inputs,
  nixpkgs,
  nixpkgs-unstable,
}: name: {
  system,
  darwin ? false,
  wsl ? false,
}: let
  localOverlay = import ../overlays;

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [localOverlay];
  };

  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  systemFunc =
    if darwin
    then inputs.nix-darwin.lib.darwinSystem
    else nixpkgs.lib.nixosSystem;

  systemType =
    if darwin
    then "darwin"
    else if wsl
    then "wsl"
    else "nixos";
in
  systemFunc rec {
    specialArgs = {
      inherit self;
      inherit name;
      inherit inputs;
      inherit pkgs-unstable;
    };

    modules = [
      # If building a WSL machine, include the relevant import.
      (
        if wsl
        then inputs.nixos-wsl.nixosModules.wsl
        else {}
      )

      {nixpkgs.pkgs = pkgs;}
      ../hosts/${systemType}/${name}/default.nix

      # Expose the Darwin and WSL variables for usage within modules.
      {
        config._module.args = {
          isDarwin = darwin;
          isWsl = wsl;
        };
      }
    ];
  }
