{
  lib,
  config,
  ...
}: let
  cfg = config.wslSettings.docker;
in {
  options.wslSettings.docker = {
    enable = lib.mkEnableOption "Enable WSL docker integration";
  };

  config = lib.mkIf cfg.enable {
    # Enable Docker desktop integration on top of regular Docker.
    wsl.docker-desktop.enable = true;
  };
}
