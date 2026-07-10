# Desktop specific config.
{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ../../../vars
    ./hardware-configuration.nix

    ../../../modules/nixos
    ../../../modules/users
  ];

  users.mantissa.enable = true;

  systemSettings = {
    adb.enable = true;
    cinnamon.enable = true;
    grub.enable = true;
    nvidia.enable = true;
    packages.extra.enable = true;
    pipewire.enable = true;
    steam.enable = true;
  };

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
      input-leap
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
