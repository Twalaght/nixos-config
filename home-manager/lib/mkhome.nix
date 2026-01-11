# Create a user home with standardised config.
{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  dotfiles,
  nix-vscode-extensions,
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

  vscode-extensions = nix-vscode-extensions.extensions.${system};
in
  home-manager.lib.homeManagerConfiguration rec {
    inherit pkgs;

    modules = [
      ../users/${name}
    ];

    extraSpecialArgs = {
      inherit name;
      inherit system;
      inherit pkgs-unstable;
      inherit dotfiles;
      inherit vscode-extensions;
    };
  }
