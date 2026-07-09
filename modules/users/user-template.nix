{
  config,
  lib,
  pkgs,
  ...
}: {
  name,
  admin ? false,
  noPassword ? false,
  username ? null,
  description ? null,
  shell ? pkgs.zsh,
  initialHashedPassword ? "$2b$12$OYdcZxJ36JbTLIs5mHa45eXkJGinnFgHBmo2.t9FqAEhEyeg3yqA2",
  extraGroups ? [],
  opensshKeys ? [],
}: let
  cfg = config.users.${name};
  mapping = config.vars.user_mapping.${name} or {};
  shellName = lib.getName shell;
  groups =
    if cfg.admin == true
    then ["networkmanager" "wheel"]
    else extraGroups;
  userName =
    if username == null
    then mapping.name or name
    else username;
  userDescription =
    if description == null
    then mapping.description or name
    else description;
in {
  options.users.${name} = {
    enable = lib.mkEnableOption "Enable the user account for `${name}`";
    admin = lib.mkOption {
      type = lib.types.bool;
      default = admin;
      description = "Admin status of the user";
    };
    additionalGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional groups to add the user to";
    };
    additionalAuthKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional OpenSSH authorized keys to add to the user";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.admin && noPassword);
        message = "User '${name}' cannot be admin and have no password at the same time";
      }
    ];

    users.users.${userName} = {
      isNormalUser = true;
      description = userDescription;
      extraGroups = groups ++ cfg.additionalGroups;
      inherit shell;
      password = lib.mkIf (noPassword == true) "";
      initialHashedPassword = lib.mkIf (noPassword == false && initialHashedPassword != null) initialHashedPassword;
      openssh.authorizedKeys.keys = opensshKeys ++ cfg.additionalAuthKeys;
    };

    # Enable the program associated with the users shell.
    # If they want something other than zsh/fish/bash, let them enable the program themselves.
    programs.zsh.enable = lib.mkIf (shellName == "zsh") (lib.mkDefault true);
    programs.fish.enable = lib.mkIf (shellName == "fish") (lib.mkDefault true);

    # Make default groups if they were not already defined.
    users.groups = builtins.listToAttrs (
      map (group: {
        name = group;
        value = lib.mkDefault {};
      })
      (groups ++ cfg.additionalGroups)
    );
  };
}
