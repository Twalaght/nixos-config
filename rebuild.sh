#!/usr/bin/env bash

# To update the flake:
# nix flake update

sudo nixos-rebuild switch --flake .#server

