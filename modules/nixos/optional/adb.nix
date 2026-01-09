# Android Debug Bridge.
{config, ...}: {
  programs.adb.enable = true;
  users.users."${config.vars.user_mapping.mantissa.name}".extraGroups = ["adbusers"];
}
