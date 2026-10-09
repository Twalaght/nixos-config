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
    [
      inputs.alga.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
    ++ (with pkgs; [
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
        # extraPackages = with pkgs-unstable; [
        #   kdePackages.plasma-bigscreen
        # ];
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

  systemd.services.alga-power-on = {
    description = "Power on and select HDMI1 via alga";

    wantedBy = ["default.target"];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Environment = [
        "HOME=/root"
        "XDG_CONFIG_HOME=/root/.config"
      ];

      ExecStart = pkgs.writeShellScript "alga-power-on" ''
        echo "Running: alga power on"
        until ${inputs.alga.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/alga power on; do
          echo "alga power on failed; retrying in 1 second..."
          sleep 1
        done

        until ${inputs.alga.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/alga input set HDMI_1; do
          echo "alga input set HDMI1 failed; retrying in 1 second..."
          sleep 1
        done

        echo "HDMI_1 selected successfully."
      '';

      RemainAfterExit = true;
    };
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
  services.blueman.enable = true;

  systemSettings.networking.hostname = "elster";

  system.stateVersion = "25.11";
}
