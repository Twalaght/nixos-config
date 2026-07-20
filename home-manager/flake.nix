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
    # List of users and supported system architectures to make configurations for.
    users = ["mantissa" "mantissa-desktop" "glorp"];
    systems = ["x86_64-linux" "x86_64-darwin"];

    # Import the home helper function with required inputs.
    mkHome = import ./lib/mkhome.nix {
      inherit self inputs nixpkgs nixpkgs-unstable home-manager;
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
