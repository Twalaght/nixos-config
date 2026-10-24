# Alga package and boot script config.
{
  lib,
  config,
  ...
}: let
  cfg = config.systemSettings.alga;
in {
  options.systemSettings.alga = {
    enable = lib.mkEnableOption "Enable Alga packages and settings";
    enableBootService = lib.mkEnableOption "Enable Alga boot power and selection service";
    inputName = lib.mkOption {
      type = lib.types.str;
      default = "HDMI_1";
      description = "Input to select";
    };
  };

  config = lib.mkIf cfg.enable {
    # Install the Alga package from the associated flake.
    environment.systemPackages = [inputs.alga.packages.${pkgs.stdenv.hostPlatform.system}.default];

    systemd.services.alga-power-on = lib.mkIf cfg.enableBootService {
      description = "Power on and select the ${cfg.inputName} input via Alga";
      wantedBy = ["default.target"];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = pkgs.writeShellScript "alga-power-on" ''
          echo "Running: alga power on"
          until ${inputs.alga.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/alga power on; do
              echo "alga power on failed; retrying in 1 second..."
              sleep 1
          done

          until ${inputs.alga.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/alga input set ${cfg.inputName}; do
              echo "alga input set ${cfg.inputName} failed; retrying in 1 second..."
              sleep 1
          done

          echo "HDMI_1 selected successfully."
        '';
        RemainAfterExit = true;
      };
    };
  };
}
