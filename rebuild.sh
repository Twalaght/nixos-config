#!/usr/bin/env bash

if [ -z "${NIXOS_SYSTEM_FLAKE_CONFIGURATION}" ]; then
	echo "NIXOS_SYSTEM_FLAKE_CONFIGURATION is unset, please set it before building"
	exit 1
fi

SYSTEM_TYPE="nixos"
REBUILD_COMMAND="nixos-rebuild"
if [[ "${NIXOS_SYSTEM_FLAKE_CONFIGURATION}" == *-wsl ]]; then
	SYSTEM_TYPE="wsl"
elif [[ "${NIXOS_SYSTEM_FLAKE_CONFIGURATION}" == *-darwin ]]; then
	SYSTEM_TYPE="darwin"
	REBUILD_COMMAND="darwin-rebuild"
fi

HARDWARE_FILE="hosts/${SYSTEM_TYPE}/${NIXOS_SYSTEM_FLAKE_CONFIGURATION}/hardware-configuration.nix"
if [ ! -f "${HARDWARE_FILE}" ] && [[ "${SYSTEM_TYPE}" != "wsl" ]]; then
	echo "Generating hardware config for host ${NIXOS_SYSTEM_FLAKE_CONFIGURATION}"
	nixos-generate-config --show-hardware-config >> "${HARDWARE_FILE}"
fi

sudo "${REBUILD_COMMAND}" "${1:-switch}" --flake "path:.#${NIXOS_SYSTEM_FLAKE_CONFIGURATION}"

