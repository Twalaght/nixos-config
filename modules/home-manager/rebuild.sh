#!/usr/bin/env bash

if [ -z "${HOME_MANAGER_FLAKE_CONFIGURATION}" ]; then
	echo "HOME_MANAGER_FLAKE_CONFIGURATION is unset, please set it before building"
	exit 1
fi

home-manager "${1:-switch}" --flake "path:.#${HOME_MANAGER_FLAKE_CONFIGURATION}"
