#!/usr/bin/env bash

generate_default_config () {
  echo "(import <nixpkgs/lib>).evalModules { modules = [ { imports = [.vars.nix]; } ]; }" > generate.nix
  echo "{lib, ...}: with lib.config; $(nix-instantiate --eval ./generate.nix --strict -A config)" > config.nix
  alejandra config.nix --quiet
  rm generate.nix
}

# Create a Nix shell with required programs for setup.
nix-shell -p git alejandra
git clone https://github.com/Twalaght/nixos-config.git ~/nixos-config

# Generate default vars config file for NixOS.
cd ~/nixos-config/vars
nixos-generate-config

# Generate default vars config file for home-manager.
cd ~/nixos-config/modules/home-manager/vars
nixos-generate-config

cd ~/nixos-config

echo "Done! Remember to edit your vars/config.nix and /modules/home-manager/vars/config.nix files before building"

