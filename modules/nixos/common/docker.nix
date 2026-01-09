{config, ...}: {
  virtualisation.docker.enable = true;
  virtualisation.docker.liveRestore = false;
  users.users.${config.vars.user_mapping.mantissa.name}.extraGroups = ["docker"];
}
