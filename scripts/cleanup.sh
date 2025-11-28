#!/usr/bin/env bash

sudo nix-collect-garbage
sudo nix-store --optimise
