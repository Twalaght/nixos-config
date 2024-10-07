# Desktop specific config.
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common
  ];
  # Desktop environment.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # List of packages installed in desktop profile.
  environment.systemPackages = with pkgs; [
    ffmpeg
    imagemagick
    p7zip
    python3
    ranger
    shellcheck
  ];
}
