{config, ...}: {
  virtualisation.docker.enable = true;
  virtualisation.docker.liveRestore = false;
  users.users.${config.default_user.username}.extraGroups = ["docker"];
}
