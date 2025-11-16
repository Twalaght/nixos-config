{
  config,
  lib,
  isWsl,
  ...
}: {
  virtualisation.docker.enable = true;
  virtualisation.docker.liveRestore = false;
  users.users.${config.default_user.username}.extraGroups = ["docker"];

  # Activate the relevant WSL desktop integration if system is WSL.
  wsl = lib.mkIf isWsl {
    docker-desktop.enable = true;
  };
}
