#!/usr/bin/env bash

nix repl ".#homeConfigurations.\"$HOME_MANAGER_FLAKE_CONFIGURATION\""
