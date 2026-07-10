# Optional extra system packages.
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.systemSettings.packages.extra;
in {
  options.systemSettings.packages.extra = {
    enable = lib.mkEnableOption "Enable extra default system packages";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ffmpeg
      gallery-dl
      imagemagick
    ];
  };
}
