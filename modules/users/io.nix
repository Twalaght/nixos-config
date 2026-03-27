{
  config,
  lib,
  pkgs,
  ...
}: let
  username = config.vars.user_mapping.io.name;
  inherit (config.vars.user_mapping.io) description;
  cfg = config.users.io;
in {
  options.users.io = {
    enable = lib.mkEnableOption "Enable the user account for `io`";
    additionalGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional groups to add the user to";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${username} = {
      isNormalUser = true;
      inherit description;
      extraGroups = ["networkmanager" "wheel"] ++ cfg.additionalGroups;
      shell = pkgs.zsh;
      initialHashedPassword = "$2b$12$OYdcZxJ36JbTLIs5mHa45eXkJGinnFgHBmo2.t9FqAEhEyeg3yqA2";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGojf3bWewBs4X1C8l8xG2DQZD3jcCGoB02NPt3J/ztM"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP/j+TbND/PJ2Q2qMK+JfG8xgAbDozOY8S9h3ef0qozb"
      ];
    };
    # Required as the shell is set to zsh.
    programs.zsh.enable = true;
  };
}
