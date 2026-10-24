# NixOS system settings.
{
  lib,
  config,
  systemName,
  ...
}: let
  cfg = config.systemSettings.nixos;
in {
  options.systemSettings.nixos = {
    enable = lib.mkEnableOption "Enabled default NixOS system config";
    hardwareClockInLocalTime = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Set if the hardware clock should be read in local time";
    };
  };

  config =
    lib.mkIf cfg.enable {
      # Enable flakes.
      nix.settings.experimental-features = ["nix-command" "flakes"];

      # Set a variable such that the rebuild script remembers the target config.
      environment.variables = {
        NIXOS_SYSTEM_FLAKE_CONFIGURATION = systemName;
      };

      # Manage users imperatively after initial setup.
      users.mutableUsers = true;
    }
    // {
      # Read the hardware clock in local time if required.
      time.hardwareClockInLocalTime = lib.mkIf (cfg.hardwareClockInLocalTime != null) cfg.hardwareClockInLocalTime;
    };
}
