# Common config to be shared and reusued among all hosts.
# Host specific config must be placed in the associated hosts file.
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../../modules
    ./nix.nix
    ./locale.nix
    ./users.nix
  ];

  # Define system hostname.
  networking.hostName = "${config.host.hostname}";

  # Networking.
  networking.networkmanager.enable = true;
  # Configure network proxy if necessary.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # List of packages installed in common profile.
  environment.systemPackages = with pkgs; [
    # Nix ecosystem
    alejandra
    sops
    statix

    # Standard server packages
    busybox
    git
    htop
    neofetch
    neovim
    pciutils
    stow
    wget
    zsh
  ];
}
