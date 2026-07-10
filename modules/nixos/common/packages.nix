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
    fastfetch
    file
    git
    htop
    neovim
    pciutils
    pre-commit
    ranger
    shellcheck
    stow
    wget
    zsh
  ];

  # Allow running pre-compiled executables.
  programs.nix-ld.enable = true;
}
