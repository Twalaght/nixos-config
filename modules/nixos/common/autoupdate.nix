{
  config,
  inputs,
  lib,
  system,
  ...
}: let
  cfg = config.systemSettings.autoupdate;
in {
  options.systemSettings.autoupdate = {
    enable = lib.mkEnableOption "Enable automatic system updates";
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L" # Print build logs.
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
  };
}
