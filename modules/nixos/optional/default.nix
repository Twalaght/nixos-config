{
  lib,
  config,
  ...
}: {
  imports = [
    ./adb.nix
    ./cinnamon.nix
    ./grub.nix
    ./nvidia.nix
    ./packages.nix
    ./pipewire.nix
    ./rgb.nix
    ./smb.nix
    ./steam.nix
  ];

  systemSettings = {
    # Android Debug Bridge
    adb = {
      enable = lib.mkDefault false;
      users = lib.mkDefault config.userInfo.admins;
    };

    # Cinnamon desktop environment
    cinnamon.enable = lib.mkDefault false;

    # GRUB bootloader
    grub.enable = lib.mkDefault false;

    # Nvidia
    nvidia.enable = lib.mkDefault false;

    # Packages
    packages.extra.enable = lib.mkDefault false;

    # Pipewire
    pipewire.enable = lib.mkDefault false;

    # RGB
    rgb.enable = lib.mkDefault false;

    # SMB
    smb.enable = lib.mkDefault false;

    # Steam
    steam.enable = lib.mkDefault false;
  };
}
