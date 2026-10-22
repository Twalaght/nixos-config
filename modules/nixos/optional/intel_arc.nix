# Intel Arc graphics card config.
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.systemSettings.intelArc;
in {
  options.systemSettings.intelArc = {
    enable = lib.mkEnableOption "Enable Intel Arc graphics packages and settings";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vpl-gpu-rt
        libvdpau-va-gl
        intel-media-driver
        intel-vaapi-driver
      ];
    };
  };
}
