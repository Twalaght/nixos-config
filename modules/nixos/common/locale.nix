{
  config,
  lib,
  ...
}: let
  cfg = config.systemSettings.locale;
in {
  options.systemSettings.locale = {
    enable = lib.mkEnableOption "Enable system locale settings";
    defaultLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_AU.UTF-8";
      description = "System locale";
    };
    extraLocaleSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Additional system locale overrides";
    };
    keyMap = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "System console keymap";
    };
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "Etc/UTC";
      description = "System time zone";
    };
  };

  config = lib.mkIf cfg.enable {
    # Select localisation properties.
    i18n.defaultLocale = cfg.defaultLocale;
    # i18n.extraLocaleSettings = cfg.extraLocaleSettings;

    # Configure console key map.
    console.keyMap = cfg.keyMap;

    # Set time zone.
    time.timeZone = cfg.timeZone;
  };
}
