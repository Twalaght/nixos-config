# Mount a Samba share.
{
  smbTarget,
  mountPoint,
  credentialsPath,
}: {
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  fileSystems = lib.mkIf (mountPoint != null && smbTarget != null && builtins.pathExists credentialsPath) {
    "${mountPoint}" = {
      device = "${smbTarget}";
      fsType = "cifs";
      options = [
        (lib.concatStringsSep "," [
          "uid=1000"
          "gid=1000"
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=60"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=5s"
          "user"
          "users"
          "credentials=${credentialsPath}"
        ])
      ];
    };
  };
}
