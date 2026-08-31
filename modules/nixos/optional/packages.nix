# Optional extra system packages.
{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.systemSettings.packages.extra;
in {
  options.systemSettings.packages.extra = {
    enable = lib.mkEnableOption "Enable extra default system packages";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      [
        inputs.furbox.packages.${pkgs.stdenv.hostPlatform.system}.default
      ]
      ++ (with pkgs; [
        nicotine-plus
        ffmpeg
        gallery-dl
        imagemagick
      ]);
  };
}
