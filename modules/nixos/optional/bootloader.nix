# Enable the GRUB bootloader.
{...}: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = ["nodev"]; # For desktop with split EFI partitions.
      efiSupport = true;
      useOSProber = true;

      # Default to last booted GRUB entry.
      default = "saved";
      extraEntries = "GRUB_SAVEDEFAULT=true";
    };
  };
}
