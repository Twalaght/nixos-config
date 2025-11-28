# Android Debug Bridge.
{config, ...}: {
  programs.adb.enable = true;
  users.users."${config.default_user.username}".extraGroups = ["adbusers"];
}
