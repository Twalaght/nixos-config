{
  config,
  lib,
  pkgs,
  systemName,
  ...
}: {
  name,
  admin ? false,
  noPassword ? false,
  shell ? pkgs.zsh,
  initialHashedPassword ? "$2b$12$OYdcZxJ36JbTLIs5mHa45eXkJGinnFgHBmo2.t9FqAEhEyeg3yqA2",
  extraGroups ? [],
  opensshKeys ? [],
}: let
  cfg = config.users.${name};
  mapping = config.vars.${systemName}.userMapping.${name};
  shellName = lib.getName shell;
  groups =
    (
      if cfg.admin == true
      then ["networkmanager" "wheel"]
      else []
    )
    ++ extraGroups ++ cfg.extraGroups;
in {
  options.users.${name} = {
    enable = lib.mkEnableOption "Enable the user account for `${name}`";
    admin = lib.mkOption {
      type = lib.types.bool;
      default = admin;
      description = "Admin status of the user";
    };
    username = lib.mkOption {
      type = lib.types.str;
      default = mapping.name;
      description = "Name of the user account";
    };
    description = lib.mkOption {
      type = lib.types.str;
      default = mapping.description;
      description = "Description of the user account";
    };
    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra groups to add the user to";
    };
    extraAuthKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra OpenSSH authorized keys to add to the user";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.admin && noPassword);
        message = "User '${name}' cannot be admin and have no password at the same time";
      }
    ];

    users.users.${cfg.username} = {
      isNormalUser = true;
      inherit (cfg) description;
      extraGroups = groups;
      inherit shell;
      password = lib.mkIf (noPassword == true) "";
      initialHashedPassword = lib.mkIf (noPassword == false && initialHashedPassword != null) initialHashedPassword;
      openssh.authorizedKeys.keys = opensshKeys ++ cfg.extraAuthKeys;
    };

    # Enable the program associated with the users shell.
    # If they want something other than zsh/fish/bash, let them enable the program themselves.
    programs.zsh.enable = lib.mkIf (shellName == "zsh") (lib.mkDefault true);
    programs.fish.enable = lib.mkIf (shellName == "fish") (lib.mkDefault true);

    # Make default groups if they were not already defined.
    users.groups = lib.genAttrs groups (group: lib.mkDefault {});

    # Add the user to the admins and trusted users list, if they were an admin.
    userInfo.admins = lib.mkIf (admin == true) [cfg.username];
    nix.settings.trusted-users = lib.mkIf (admin == true) [cfg.username];
  };
}
