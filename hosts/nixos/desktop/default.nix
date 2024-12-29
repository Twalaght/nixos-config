# Desktop specific config.
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../../../vars
    ./hardware-configuration.nix

    ../../common/users/default_user.nix

    ../../../modules/nixos/common
    ../../../modules/nixos/optional/bootloader.nix
    ../../../modules/nixos/optional/pipewire.nix
  ];

  # Set a variable such that the rebuild script remembers the target config.
  environment.variables = {
    NIXOS_SYSTEM_FLAKE_CONFIGURATION = "desktop";
  };

  # List of packages installed in desktop profile.
  environment.systemPackages = with pkgs; [
    ffmpeg
    imagemagick
    p7zip
    python3
    ranger
    shellcheck
    rsync

    firefox
    steam
    (discord.override {
      withVencord = true;
    })
    bitwarden
    vscode
    signal-desktop
    obsidian
    barrier
    alacritty
    jellyfin-media-player

    wine64
    bottles
  ];

  # GNOME Desktop environment.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Configure keymap in X.
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
