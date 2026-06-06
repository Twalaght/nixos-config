#!/usr/bin/env bash

optimise=""
expiry=""
while test $# -gt 0; do
	case "$1" in
	-h|--help)
		echo "options:"
		echo "--optimise  optimise the nix-store"
		echo "--expiry	  'older than N days' expiry to use when expiring old generations"
		echo "			  if unset will not expiry any, if set to 'all' will expire all generations"
		echo "-h, --help  show this message and exit"
		exit 0
		;;
	--optimise)
		shift
		optimise="true"
		;;
	--expiry*)
		shift
		if ! test $# -gt 0; then
		echo "no expiry specified"
		exit 1
		fi
		expiry=${1#*=}
		shift
		;;
	*)
		echo "invalid argument '$1'"
		exit 1
		;;
	esac
done

if [[ -n "$expiry" ]]; then
	echo "Running nix garbage collection..."
	if [[ "$expiry" != "all" ]]; then
		echo "Expiring generations older than $expiry days"
		# command -v home-manager &> /dev/null && home-manager expire-generations "-${expiry}" days
		# nix-collect-garbage --delete-older-than "${expiry}d"
		# sudo nix-collect-garbage --delete-older-than "${expiry}d"
	else
		echo "Expiring all previous generations"
		# command -v home-manager &> /dev/null && home-manager expire-generations -0 days
		# nix-collect-garbage -d
		# sudo nix-collect-garbage -d
	fi
	exit 0
fi

if [[ "$optimise" == "true" ]]; then
	echo "Optimising nix-store..."
	nix-store --optimise
	echo "Optimising nix-store with sudo..."
	sudo nix-store --optimise
	echo "Done"
	exit 0
fi

