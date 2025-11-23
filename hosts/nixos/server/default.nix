# Server specific config.
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../../vars
    ../../../secrets

    ./hardware-configuration.nix

    ../../common/users/default-user.nix

    ../../../modules/nixos/common
    ../../../modules/nixos/optional/bootloader.nix

    (import ../../../modules/nixos/optional/smb.nix {
      smbTarget = "//10.25.0.196/toasterdog";
      mountPoint = "/mnt/wolfram";
      credentialsPath = ''${config.sops.secrets."server/smb/wolfram".path}'';
    })

    (import ../../../modules/nixos/optional/smb.nix {
      smbTarget = "//10.25.0.123/sambashare";
      mountPoint = "/mnt/toasterdog";
      credentialsPath = ''${config.sops.secrets."server/smb/hightower".path}'';
    })
  ];

  # Set SMB config secrets owner for all config files.
  sops.secrets =
    lib.genAttrs ["server/smb/wolfram" "server/smb/hightower"]
    (_: {owner = config.users.users.${config.default_user.username}.name;});

  # Fix for virtual machine hardware passthrough.
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Open ports for web hosting.
  networking.firewall.allowedTCPPorts = [80 443];
  networking.firewall.allowedUDPPorts = [80 443];

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
