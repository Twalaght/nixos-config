{
  config,
  lib,
  ...
}: let
  cfg = config.systemSettings.docker;
in {
  options.systemSettings.docker = {
    enable = lib.mkEnableOption "Enable Docker";
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Users to add to the Docker group";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    virtualisation.docker.liveRestore = false;

    # Add users to the Docker group.
    users.users = builtins.listToAttrs (map (user: {
        name = user;
        value.extraGroups = ["docker"];
      })
      cfg.users);
  };
}
