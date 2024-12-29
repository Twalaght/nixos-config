# Enable the GRUB bootloader.
{...}: {
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };
}
