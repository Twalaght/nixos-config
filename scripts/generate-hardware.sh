#!/usr/bin/env bash

export NIXOS_SYSTEM_FLAKE_CONFIGURATION=${1:-server}

nixos-generate-config && cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/"${NIXOS_SYSTEM_FLAKE_CONFIGURATION}"/hardware-configuration.nix

sudo nixos-rebuild switch --flake "path:.#${NIXOS_SYSTEM_FLAKE_CONFIGURATION}"
