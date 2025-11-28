# Android Debug Bridge.
{
  pkgs,
  config,
  ...
}: {
  programs.adb.enable = true;
  users.users."${config.default_user.username}".extraGroups = ["adbusers"];

  environment.systemPackages = with pkgs; [
    better-adb-sync
  ];
}
