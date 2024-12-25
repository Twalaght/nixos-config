{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  # Common system packages.
  environment.systemPackages = with pkgs; [
    # Nix ecosystem.
    alejandra
    sops
    statix

    # Standard system packages.
    bash
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
