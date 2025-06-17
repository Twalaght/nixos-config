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
    nix-vscode-extensions,
    dotfiles,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    vscode-extensions = nix-vscode-extensions.extensions.${system};
  in {
    home-manager.useGlobalPkgs = true;
    homeConfigurations."admin" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [./users/admin.nix];

      # Optionally use extraSpecialArgs to pass through arguments to home.nix.
      extraSpecialArgs = {
        inherit pkgs-unstable;
        inherit dotfiles;
        inherit vscode-extensions;
      };
    };
  };
}
