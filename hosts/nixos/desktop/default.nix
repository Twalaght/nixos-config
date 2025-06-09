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
    ../../../modules/nixos/optional/cinnamon.nix
    ../../../modules/nixos/optional/nvidia.nix
    ../../../modules/nixos/optional/pipewire.nix
    ../../../modules/nixos/optional/steam.nix
  ];

  # Set a variable such that the rebuild script remembers the target config.
  environment.variables = {
    NIXOS_SYSTEM_FLAKE_CONFIGURATION = "desktop";
  };

  # List of packages installed in desktop profile.
  environment.systemPackages = with pkgs; [
    ffmpeg
    imagemagick

    feishin
    mpv

    p7zip
    kdePackages.ark
    (gruvbox-gtk-theme.overrideAttrs {
      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/themes
        cd themes
        ./install.sh -n GruvboxPatched -c dark light -t all \
          --tweaks macos -d "$out/share/themes"
        runHook postInstall
      '';
    })
    papirus-icon-theme

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
    vlc

    wine64
    bottles
  ];

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
