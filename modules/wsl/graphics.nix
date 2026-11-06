{
  pkgs,
  lib,
  config,
  systemName,
  ...
}: let
  cfg = config.wslSettings.windows;
in {
  options.wslSettings.graphics = {
    enable = lib.mkEnableOption "Enable graphics options for WSL";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;
    hardware.nvidia-container-toolkit = {
      enable = true;

      # Stops NixOS from building Linux drivers.
      suppressNvidiaDriverAssertion = true;
    };
  };
}
