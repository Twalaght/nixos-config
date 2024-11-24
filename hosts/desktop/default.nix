# Desktop specific config.
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../../vars
    ./hardware-configuration.nix
    ../common
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
  ];

  # GNOME Desktop environment.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
