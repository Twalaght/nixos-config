{
  system,
  inputs,
  ...
}: {
  # Enable the GRUB bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
}
