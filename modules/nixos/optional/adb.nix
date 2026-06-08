# Android Debug Bridge.
{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    android-tools
  ];
  # programs.adb.enable = true;

  users.users."${config.vars.user_mapping.mantissa.name}".extraGroups = ["adbusers"];
}
