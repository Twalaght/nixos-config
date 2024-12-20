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
    inputs.home-manager.nixosModules.default
  ];

  # Enable home manager for the default user.
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "${config.default_user.username}" = import ../../modules/home-manager/desktop.nix;
    };
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
}
