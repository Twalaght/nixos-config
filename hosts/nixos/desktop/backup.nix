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

  # Set a variable such that the rebuild script remembers the target config.
  environment.variables = {
    NIXOS_SYSTEM_FLAKE_CONFIGURATION = "desktop";
  };

  # GNOME Desktop environment.
  # services.xserver = {
  #   enable = true;
  #   displayManager.gdm.enable = true;
  #   desktopManager.gnome.enable = true;
  # };

  # Enable home manager for the default user.
  home-manager = {
    useGlobalPkgs = true;
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

    alacritty
    firefox
    librewolf
    bottles

    # TODO - Move to a module (with GNOME).
    # gnomeExtensions.dash-to-dock
    # gnomeExtensions.vitals
    # gnomeExtensions.just-perfection
    # gnomeExtensions.blur-my-shell
    # gnomeExtensions.custom-osd
  ];

  # environment.gnome.excludePackages = with pkgs.gnome; [
  #   baobab      # disk usage analyzer
  #   cheese      # photo booth
  #   eog         # image viewer
  #   epiphany    # web browser
  #   # gedit       # text editor
  #   simple-scan # document scanner
  #   totem       # video player
  #   yelp        # help viewer
  #   evince      # document viewer
  #   file-roller # archive manager
  #   geary       # email client
  #   seahorse    # password manager

  #   # these should be self explanatory
  #   gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-contacts
  #   gnome-font-viewer gnome-logs gnome-maps gnome-music
  #   # gnome-photos
  #   gnome-screenshot
  #   gnome-system-monitor gnome-weather gnome-disk-utility pkgs.gnome-connections
  # ];

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
