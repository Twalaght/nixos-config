#!/usr/bin/env bash

nix-collect-garbage
nix-store --optimise

