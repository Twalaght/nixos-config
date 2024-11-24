#!/usr/bin/env bash

if [ -z "${NIXOS_SYSTEM_FLAKE_CONFIGURATION}" ]; then
    echo "NIXOS_SYSTEM_FLAKE_CONFIGURATION is unset, please set it before building"
	exit 1
fi

sudo nixos-rebuild switch --flake "path:.#${NIXOS_SYSTEM_FLAKE_CONFIGURATION}"

