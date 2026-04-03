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

    ../../../modules/nixos/common
    ../../../modules/nixos/optional/bootloader.nix
    ../../../modules/nixos/optional/smb.nix
    ../../../modules/users
  ];

  users.mantissa.enable = true;

  # Set SMB config secrets owner for all config files.
  sops.secrets =
    lib.genAttrs ["server/smb/wolfram"]
    (_: {owner = config.users.users.${config.vars.user_mapping.mantissa.name}.name;});

  systemSettings.smb = {
    enable = true;
    shares = [
      {
        smbTarget = "//10.25.0.196/toasterdog";
        mountPoint = "/mnt/wolfram";
        credentialsPath = ''${config.sops.secrets."server/smb/wolfram".path}'';
      }
      {
        smbTarget = "//10.25.0.196/main/Media";
        mountPoint = "/mnt/wolfram_main_media";
        credentialsPath = ''${config.sops.secrets."server/smb/wolfram".path}'';
      }
    ];
  };

  # Fix for virtual machine hardware passthrough.
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Open ports for web hosting.
  networking.firewall.allowedTCPPorts = [80 443];
  networking.firewall.allowedUDPPorts = [80 443];

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
