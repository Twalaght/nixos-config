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
    # Set localisation properties.
    i18n.defaultLocale = cfg.defaultLocale;
    i18n.extraLocales = ["${cfg.defaultLocale}/UTF-8"];
    i18n.extraLocaleSettings = {
      LC_ALL = cfg.defaultLocale; # This overrides all other LC_* settings.
    };

    console.keyMap = cfg.keyMap;
    time.timeZone = cfg.timeZone;
  };
}
