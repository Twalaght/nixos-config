{
  lib,
  config,
  ...
}: let
  cfg = config.systemSettings.security;
in {
  # Hello
  options.systemSettings.security = {
    enable = lib.mkEnableOption "Enable system security defaults";
    sudoTimeout = lib.mkOption {
      type = lib.types.int;
      default = 15;
      description = "Sudo timeout in minutes";
    };
  };

  config = lib.mkIf cfg.enable {
    security.sudo.extraConfig = ''
      Defaults        timestamp_timeout=${toString cfg.sudoTimeout}
    '';
  };
}
