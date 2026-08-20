#!/usr/bin/env bash

target=""
verb=""

function usage {
    echo "Usage $0 [-t|--target HOST] REBUILD_VERB:"
    echo "--target     host machine to target and upload to"
    echo "rebuild_verb rebuild command to execute, defaults to 'switch'"
    echo "-h, --help   show this message and exit"
}

# Parse options.
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -t|--target)
            if [[ -z "$2" || "$2" =~ ^- ]]; then
                echo "Error: --target requires a non-empty argument."
                exit 1
            fi
            target="$2"
            shift 2
            ;;
        --) # End of all options.
            shift
            break
            ;;
        -*) # Handle unknown options.
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
        *) # Handle positional arguments.
            if [[ -n "$verb" ]]; then
                echo "Too many positional arguments: $1"
                usage
                exit 1
            fi
            verb="$1"
            shift
            ;;
    esac
done

if [[ -n "$target" ]]; then
    # Test the SSH connection is valid and the host is reachable.
    if ! ssh "$target" exit; then
        echo "Unable to establish SSH connection to $target"
        exit 1
    fi

    # Set the flake identifier environment variable from the host.
    NIXOS_SYSTEM_FLAKE_CONFIGURATION=$(ssh "$target" 'printenv NIXOS_SYSTEM_FLAKE_CONFIGURATION')
fi

# Prompt the user to select the flake identifier, if unset at this point.
if [ -z "${NIXOS_SYSTEM_FLAKE_CONFIGURATION}" ]; then
    echo "NIXOS_SYSTEM_FLAKE_CONFIGURATION is unset, choose a host from:"
    for host in $(find hosts -mindepth 2 -maxdepth 2 -type d -exec basename {} \; | sort); do
        echo "  - $host"
    done
    read -rp "Host: " NIXOS_SYSTEM_FLAKE_CONFIGURATION
fi

SYSTEM_TYPE="nixos"
REBUILD_COMMAND="nixos-rebuild"
if [[ "${NIXOS_SYSTEM_FLAKE_CONFIGURATION}" == *-wsl ]]; then
    SYSTEM_TYPE="wsl"
elif [[ "${NIXOS_SYSTEM_FLAKE_CONFIGURATION}" == *-darwin ]]; then
    SYSTEM_TYPE="darwin"
    REBUILD_COMMAND="darwin-rebuild"
fi

# Verify the rebuild command is present on the system.
if ! command -v "$REBUILD_COMMAND" &> /dev/null; then
    echo "$REBUILD_COMMAND is not installed on the system"
    exit 1
fi

# Generate a hardware file for the machine if it does not already exist.
HARDWARE_FILE="hosts/${SYSTEM_TYPE}/${NIXOS_SYSTEM_FLAKE_CONFIGURATION}/hardware-configuration.nix"
if [ ! -f "${HARDWARE_FILE}" ] && [[ "${SYSTEM_TYPE}" == "nixos" ]]; then
    echo "Generating hardware config for host ${NIXOS_SYSTEM_FLAKE_CONFIGURATION}"
    ${TARGET:+"ssh $target"} nixos-generate-config --show-hardware-config >> "${HARDWARE_FILE}"
fi

sudo "${REBUILD_COMMAND}" "${verb:-switch}" \
    --flake "path:.#${NIXOS_SYSTEM_FLAKE_CONFIGURATION}" \
    ${TARGET:+"--target-host $target --ask-sudo-password"}
