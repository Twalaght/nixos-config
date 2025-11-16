#!/usr/bin/env bash

generate_default_config () {
  echo "{lib, ...}: with lib.config; $(
    nix-instantiate --eval --expr \
    '(import <nixpkgs/lib>).evalModules{modules=[{imports=[./vars.nix];}];}' \
    --strict -A config
  )" | alejandra --quiet > config.nix
}

# Create a Nix shell with required programs for setup.
nix-shell -p git alejandra
git clone https://github.com/Twalaght/nixos-config.git ~/nixos-config

# Generate default vars config file for NixOS.
(
	cd ~/nixos-config/vars || { echo "NixOS vars directory does not exist"; exit 1; }
	generate_default_config
)

# Generate default vars config file for home-manager.
(
	cd ~/nixos-config/modules/home-manager/vars || { echo "Home manager vars directory does not exist"; exit 1; }
	generate_default_config
)

echo "Done! Remember to edit your vars/config.nix and /modules/home-manager/vars/config.nix files before building"

