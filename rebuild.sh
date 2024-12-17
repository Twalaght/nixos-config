#!/usr/bin/env bash

if [ -z "${NIXOS_SYSTEM_FLAKE_CONFIGURATION}" ]; then
	echo "NIXOS_SYSTEM_FLAKE_CONFIGURATION is unset, please set it before building"
	exit 1
fi

HARDWARE_FILE="hosts/${NIXOS_SYSTEM_FLAKE_CONFIGURATION}/hardware-configuration.nix"
if [ ! -f "${HARDWARE_FILE}" ]; then
	echo "Generating hardware config for host ${NIXOS_SYSTEM_FLAKE_CONFIGURATION}"
	nixos-generate-config --show-hardware-config >> "${HARDWARE_FILE}"
fi

sudo nixos-rebuild switch --flake "path:.#${NIXOS_SYSTEM_FLAKE_CONFIGURATION}"

