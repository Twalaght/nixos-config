{
  config,
  lib,
  pkgs,
  ...
}: let
  username = config.vars.user_mapping.mantissa.name;
  inherit (config.vars.user_mapping.mantissa) description;
  cfg = config.users.mantissa;
in {
  options.users.mantissa = {
    enable = lib.mkEnableOption "Enable the user account for `mantissa`";
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/RgCQjdF6x7t0fNFAnhSUDLiyrVtez62MLBo6Kf3J+"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfpDJbb+8RoCjec6dD0k1YzXqLlHrn5yx5cI3UXIyyV"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5fORGIpVoiY5OTqPXYypWgrky1V3PqX9qry0kkjAWk"
      ];
    };
    # Required as the shell is set to zsh.
    programs.zsh.enable = true;
  };
}
