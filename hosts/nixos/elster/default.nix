# Media PC config
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
    ../../../modules/nixos
    ../../../modules/users
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
    pipewire.enable = true;
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
        user = "glorp";
      };

      defaultSession = "plasma-bigscreen-wayland";

      sessionPackages = with pkgs-unstable; [
        kdePackages.plasma-bigscreen
      ];

      sddm = {
        enable = true;
        wayland.enable = true;
        extraPackages = with pkgs-unstable; [
          kdePackages.plasma-bigscreen
        ];
      };
    };
  };

  # Intel Arc B570 Drivers
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      libvdpau-va-gl
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  # Load Bluetooth-related kernel modules at boot
  boot.kernelModules = ["usb" "xhci_hcd" "btusb" "bluetooth"];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Name = "elster"; # Used my pc's name
        ControllerMode = "dual";
        FastConnectable = true;
        Experimental = true;
      };
      Policy = {AutoEnable = true;};
      # 1 is enabled and is enabled by default
      LE = {EnableAdvMonInterleaveScan = "1";};
    };
  };

  system.stateVersion = "25.11";
}
