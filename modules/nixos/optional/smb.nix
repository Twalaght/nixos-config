{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.systemSettings.smb;
in {
  options.systemSettings.smb = {
    enable = lib.mkEnableOption "Enable SMB share support";
    shares = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          smbTarget = lib.mkOption {
            type = lib.types.str;
            description = "Target SMB path to mount";
          };
          mountPoint = lib.mkOption {
            type = lib.types.str;
            description = "Local mount path";
          };
          options = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "uid=1000"
              "gid=1000"
              "noauto"
              "x-systemd.automount"
              "x-systemd.idle-timeout=60"
              "x-systemd.device-timeout=5s"
              "x-systemd.mount-timeout=5s"
              "user"
              "users"
            ];
            description = "Mounting options";
          };
          credentialsPath = lib.mkOption {
            type = lib.types.str;
            description = "Path to credentials file";
          };
        };
      });
      default = {};
      description = "List of SMB shares to mount";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cifs-utils
    ];

    # Generate the fileSystems configuration dynamically
    fileSystems = builtins.listToAttrs (map (share: {
        name = share.mountPoint;
        value = {
          device = "${share.smbTarget}";
          fsType = "cifs";
          options = [
            (lib.concatStringsSep ","
              (share.options
                ++ [
                  "credentials=${share.credentialsPath}"
                ]))
          ];
        };
      })
      cfg.shares);
  };
}
