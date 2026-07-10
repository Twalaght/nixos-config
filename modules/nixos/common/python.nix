{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.systemSettings.python;
in {
  options.systemSettings.python = {
    enable = lib.mkEnableOption "Install Python and UV";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      python314
      uv
    ];
  };
}
