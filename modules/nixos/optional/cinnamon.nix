# Cinnamon desktop environment.
{
  lib,
  config,
  ...
}: let
  cfg = config.systemSettings.cinnamon;
in {
  options.systemSettings.cinnamon = {
    enable = lib.mkEnableOption "Enable Cinnamon desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services = {
      libinput.enable = true;
      displayManager.defaultSession = "cinnamon";
      xserver = {
        enable = true;
        displayManager.lightdm.enable = true;
        desktopManager = {
          cinnamon.enable = true;
        };
      };
    };
  };
}
