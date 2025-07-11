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

    ../../common/users/default_user.nix

    ../../../modules/nixos/common
    ../../../modules/nixos/optional/bootloader.nix

    (import ../../../modules/nixos/optional/smb.nix {
      smbTarget = "//10.25.0.196/toasterdog";
      mountPoint = "/mnt/wolfram";
      credentialsPath = ''${config.sops.secrets."server/smb/config".path}'';
    })
  ];

  # Set SMB config secrets owner.
  sops.secrets."server/smb/config" = {
    owner = config.users.users.${config.default_user.username}.name;
  };

  # Set a variable such that the rebuild script remembers the target config.
  environment.variables = {
    NIXOS_SYSTEM_FLAKE_CONFIGURATION = "server";
  };

  # Fix for virtual machine hardware passthrough.
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Open ports for web hosting.
  networking.firewall.allowedTCPPorts = [80 443];
  networking.firewall.allowedUDPPorts = [80 443];

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
