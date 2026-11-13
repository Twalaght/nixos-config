{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    dotfiles = {
      url = "github:twalaght/dotfiles";
      flake = false;
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    # Import the home helper function with required inputs.
    mkHome = import ./lib/mkhome.nix {
      inherit self inputs nixpkgs nixpkgs-unstable home-manager;
    };

    # Mapping of all users to their associated variant configs, and supported system types.
    users = {
      mantissa = ["default" "desktop"];
      glorp = ["default"];
    };
    systems = ["x86_64-linux" "aarch64-darwin"];
  in {
    home-manager.useGlobalPkgs = true;

    homeConfigurations = builtins.listToAttrs (
      nixpkgs.lib.flatten (
        nixpkgs.lib.mapAttrsToList
        (
          user: variants:
            map
            (
              variant:
                map
                (system: {
                  name = "${user}-${variant}-${system}";
                  value = mkHome {inherit user variant system;};
                })
                systems
            )
            variants
        )
        users
      )
    );
  };
}
