{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  systemName,
  ...
}: {
  imports = [
    ../../../vars
    ../../../modules/nixos
    ../../../modules/users
    ../../../modules/wsl
  ];

  programs.ssh.startAgent = true;

  # Explicitly disable wireless to avoid WPA supplicant having issues.
  networking.wireless.enable = lib.mkForce false;

  # Common system packages.
  environment.systemPackages = with pkgs; [
    hugo
    yt-dlp
  ];

  users.mantissa.enable = true;

  systemSettings = {
    adb.enable = true;
    packages.extra.enable = true;
    security.sudoTimeout = 60;
  };

  wslSettings = {
    docker.enable = true;
    windows.enable = true;
  };

  wsl = {
    enable = true;
    defaultUser = config.users.mantissa.username;
    wslConf.automount.options = "metadata";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
