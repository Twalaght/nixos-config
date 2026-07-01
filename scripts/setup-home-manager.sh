#!/usr/bin/env bash

# Search the flake and extract the home manager version being used.
nixpkgs=$(grep nixpkgs.url ./home-manager/flake.nix)
version="${nixpkgs##*-}"
version="${version%\";*}"

# Install home manager using channels to bootstrap.
nix-channel --add "https://github.com/nix-community/home-manager/archive/release-${version}.tar.gz" home-manager
nix-channel --update
nix-shell "<home-manager>" -A install
