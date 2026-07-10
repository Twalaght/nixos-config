{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.systemSettings.packages;
in {
  options.systemSettings.packages = {
    enable = lib.mkEnableOption "Enable default system packages";
  };

  config = lib.mkIf cfg.enable {
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

    # TODO - Need to make this it's own module.
    # Allow running pre-compiled executables.
    programs.nix-ld.enable = true;
  };
}
