{
  config,
  lib,
  pkgs-custom,
  ...
}: let
  cfg = config.homeSettings.photogimp;
in {
  options.homeSettings.photogimp = {
    enable = lib.mkEnableOption "Enable Photoshop style config with GIMP";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs-custom.photogimp];
  };
}
