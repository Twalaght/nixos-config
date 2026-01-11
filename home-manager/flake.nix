{
  description = "Home Manager configuration for all users";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    dotfiles = {
      url = "github:twalaght/dotfiles";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    dotfiles,
    nix-vscode-extensions,
    ...
  } @ inputs: let
    # List of users and supported system architectures to make configurations for.
    users = ["mantissa" "mantissa-desktop"];
    systems = ["x86_64-linux" "x86_64-darwin"];

    # Import the home helper function with required inputs.
    mkHome = import ./lib/mkhome.nix {
      inherit inputs nixpkgs nixpkgs-unstable home-manager dotfiles nix-vscode-extensions;
    };
  in {
    home-manager.useGlobalPkgs = true;
    homeConfigurations = nixpkgs.lib.listToAttrs (nixpkgs.lib.concatMap
      (user:
        map (system: {
          name = "${user}-${system}";
          value = mkHome user {inherit system;};
        })
        systems)
      users);
  };
}
