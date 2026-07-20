# OpenRGB utility and helper script.
{
  lib,
  config,
  myLib,
  pkgs,
  ...
}: let
  cfg = config.systemSettings.rgb;
  disabledDeviceRegex = builtins.concatStringsSep "|" cfg.disabledDevices;
  disable-rgb = pkgs.writeScriptBin "disable-rgb" ''
    #!/bin/sh

    DEVICE_NUMS=$(
      ${pkgs.openrgb}/bin/openrgb --noautoconnect --list-devices | \
      grep -E '^[0-9]+: (${disabledDeviceRegex})' | \
      cut -d: -f1
    )

    for dev_num in $DEVICE_NUMS; do
      ${pkgs.openrgb}/bin/openrgb --noautoconnect --device "$dev_num" --mode static --color 000000
    done
  '';
in {
  options.systemSettings.rgb = {
    enable = lib.mkEnableOption "Enable OpenRGB config";
    disabledDevices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of device names to disable RGB for";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      server.port = 6742;
    };

    systemd.services.disable-rgb = lib.mkIf (cfg.disabledDevices != []) {
      description = "disable-rgb";
      serviceConfig = {
        ExecStart = "${disable-rgb}/bin/disable-rgb";
        Type = "oneshot";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
