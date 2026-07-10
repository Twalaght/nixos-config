{
  lib,
  config,
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

  config = lib.mkIf cfg.enable {
    networking = {
      # Enable networking.
      networkmanager.enable = true;

      # Define system hostname.
      hostName = cfg.hostname;

      # Configure network proxy if necessary.
      proxy = {
        default = lib.mkIf (cfg.proxy != null) cfg.proxy;
        noProxy = lib.mkIf (cfg.noProxy != null) cfg.noProxy;
      };
    };
  };
}
