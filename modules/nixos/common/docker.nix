{config, ...}: {
  virtualisation.docker.enable = true;
  users.users.${config.default_user.username}.extraGroups = ["docker"];
}
