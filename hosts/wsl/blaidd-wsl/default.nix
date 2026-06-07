{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../../../vars
    ../../../modules/nixos/common
    ../../../modules/nixos/optional/adb.nix
    ../../../modules/nixos/optional/desktop-cli.nix
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

  wsl = {
    enable = true;
    defaultUser = config.vars.user_mapping.mantissa.name;
    wslConf.automount.options = "metadata";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
