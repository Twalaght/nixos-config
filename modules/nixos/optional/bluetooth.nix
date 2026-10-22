# Bluetooth config.
{
  lib,
  config,
  ...
}: let
  cfg = config.systemSettings.bluetooth;
in {
  options.systemSettings.bluetooth = {
    enable = lib.mkEnableOption "Enable bluetooth packages and settings";
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "Bluetooth hostname";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Name = cfg.hostname;
          ControllerMode = "dual";
          FastConnectable = true;
          Experimental = true;
        };
      };
    };
    services.blueman.enable = true;
  };
}
