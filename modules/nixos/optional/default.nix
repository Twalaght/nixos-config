{
  lib,
  config,
  ...
}: {
  imports = [
    ./adb.nix
    ./bootloader.nix
  ];

  systemSettings = {
    # Android Debug Bridge
    adb.enable = lib.mkDefault false;
    adb.users = lib.mkDefault config.userInfo.admins;

    # GRUB bootloader
    grub.enable = lib.mkDefault false;
  };
}
