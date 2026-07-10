# NixOS system settings.
{
  name,
  lib,
  config,
  ...
}: let
  cfg = config.systemSettings.nixos;
in {
  options.systemSettings.nixos = {
    enable = lib.mkEnableOption "Enabled default NixOS system config";
    downloadBuffer = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "NixOS download buffer size in megabytes";
    };
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
        NIXOS_SYSTEM_FLAKE_CONFIGURATION = name;
      };

      # Manage users imperatively after initial setup.
      users.mutableUsers = true;
    }
    // {
      # Set the download buffer size if it was provided.
      nix.settings.download-buffer-size = lib.mkIf (cfg.downloadBuffer != null) (cfg.downloadBuffer * 1024 * 1024);

      # Read the hardware clock in local time if required.
      time.hardwareClockInLocalTime = lib.mkIf (cfg.hardwareClockInLocalTime != null) cfg.hardwareClockInLocalTime;
    };
}
