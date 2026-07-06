# Create a user home with standardised config.
{
  self,
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
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
in
  inputs.home-manager.lib.homeManagerConfiguration rec {
    extraSpecialArgs =
      inputs
      // {
        inherit self;
        inherit inputs;
        inherit pkgs-unstable;
      };

    inherit pkgs;

    modules = [
      ../users/${name}

      {
        config._module.args = {
          inherit name;
          inherit system;
        };
      }
    ];
  }
