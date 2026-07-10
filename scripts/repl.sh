#!/usr/bin/env bash

nix repl ".#nixosConfigurations.\"$NIXOS_SYSTEM_FLAKE_CONFIGURATION\""
