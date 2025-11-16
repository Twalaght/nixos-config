# Create a NixOS/Darwin/WSL system with standardised config.
{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
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

  systemType =
    if darwin
    then "darwin"
    else if wsl
    then "wsl"
    else "nixos";
in
  nixpkgs.lib.nixosSystem rec {
    specialArgs = {
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
