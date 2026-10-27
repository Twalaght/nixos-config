# Media PC config
{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  systemName,
  ...
}: {
  imports = [
    ../../../modules
    ../../../vars
    ./hardware-configuration.nix
    ./modules
  ];

  users = {
    io = {
      enable = true;
      extraGroups = ["admin"];
    };
    mantissa = {
      enable = true;
      extraGroups = ["admin"];
    };

    glorp.enable = true;
  };

  systemSettings = {
    alga = {
      enable = true;
      enableBootService = true;
      inputName = "HDMI_1";
    };
    bluetooth = {
      enable = true;
      hostname = config.vars.${systemName}.hostname;
    };
    pipewire.enable = true;
    intelArc.enable = true;
    steam.enable = true;
    grub.enable = true;

    rgb = {
      enable = true;
      disabledDevices = [
        "Kingston Fury DDR5 DRAM"
        "ASRock B650I Lightning WiFi"
      ];
    };
  };

  environment.systemPackages =
    (with pkgs; [
      freetube
      kitty
      moonlight-qt
      librewolf
      mpv
      vlc
      zsh
    ])
    ++ (with pkgs-unstable; [
      kdePackages.plasma-bigscreen
      kdePackages.kdeconnect-kde
      libcec
    ]);

  # Fonts
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.hurmit
    nerd-fonts.space-mono
  ];

  services = {
    xserver.enable = true; # optional
    desktopManager.plasma6.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = config.users.glorp.username;
      };

      defaultSession = "plasma-bigscreen-wayland";

      sessionPackages = with pkgs-unstable; [
        kdePackages.plasma-bigscreen
      ];

      sddm = {
        enable = true;
        wayland.enable = true;
        # extraPackages = with pkgs-unstable; [
        #   kdePackages.plasma-bigscreen
        # ];
      };
    };
  };

  system.stateVersion = "25.11";
}
