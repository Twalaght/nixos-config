{
  system,
  inputs,
  ...
}: {
  # Enable the GRUB bootloader.
  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
       enable = true;
       device = "nodev";
       efiSupport = true;
       # efiInstallAsRemovable = true;
       useOSProber = true;
       # extraEntries = ''
       #   menuentry "Windows 10" --class windows --class os {
       #     insmod ntfs
       #     search --no-floppy --set=root --fs--uuid 1E4EFE7C4EFE4BD1
       #     ntldr /bootmgr
       #   }
       # '';
    };
  };




  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sda";
  # boot.loader.grub.useOSProber = true;
}
