# GRUB bootloader.
{
  config,
  lib,
  ...
}: let
  cfg = config.systemSettings.grub;
in {
  options.systemSettings.grub = {
    enable = lib.mkEnableOption "Enable GRUB";
  };

  config = lib.mkIf cfg.enable {
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

        # Enable memtest for debug purposes.
        memtest86.enable = true;
      };
    };
  };
}
