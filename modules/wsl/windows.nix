# NixOS system settings.
{
  lib,
  config,
  systemName,
  ...
}: let
  cfg = config.wslSettings.windows;
in {
  options.wslSettings.windows = {
    enable = lib.mkEnableOption "Enabled Windows integration in WSL";
  };

  config = lib.mkIf cfg.enable {
    # Register Windows executables.
    wsl.interop.register = true;
  };
}
