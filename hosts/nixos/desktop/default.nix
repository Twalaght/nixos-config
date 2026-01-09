# Desktop specific config.
{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../../../vars
    ./hardware-configuration.nix

    ../../../modules/nixos/common
    ../../../modules/nixos/optional/adb.nix
    ../../../modules/nixos/optional/bootloader.nix
    ../../../modules/nixos/optional/cinnamon.nix
    ../../../modules/nixos/optional/desktop-cli.nix
    ../../../modules/nixos/optional/nvidia.nix
    ../../../modules/nixos/optional/pipewire.nix
    ../../../modules/nixos/optional/steam.nix
    ../../../modules/users
  ];

  users.mantissa.enable = true;

  # List of packages installed in desktop profile.
  environment.systemPackages =
    (with pkgs; [
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

      ranger
      shellcheck
      rsync

      firefox
      steam

      vscode
      signal-desktop
      obsidian
      barrier
      alacritty
      jellyfin-media-player
      vlc

      wineWowPackages.stable
      winetricks
      bottles
    ])
    ++ (with pkgs-unstable; [
      bitwarden-desktop
      discord
    ]);

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
