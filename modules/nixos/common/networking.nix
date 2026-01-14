{
  config,
  lib,
  ...
}: let
  cfg = config.systemSettings.networking;
in {
  options.systemSettings.networking = {
    enable = lib.mkEnableOption "Enable system networking";
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "System hostname";
    };
    proxy = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "System networking proxy";
    };
    noProxy = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "System networking no-proxy list";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        # Enable networking.
        networking.networkmanager.enable = true;

        # Define system hostname.
        networking.hostName = cfg.hostname;
      }

      # Configure network proxy if necessary.
      (lib.mkIf (cfg.proxy != null) {
        networking.proxy.default = cfg.proxy;
      })
      (lib.mkIf (cfg.noProxy != null) {
        networking.proxy.default = cfg.proxy;
      })
    ]
  );
}
