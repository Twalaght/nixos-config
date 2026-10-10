{
  name,
  lib,
  config,
  ...
}: let
  users = ["glorp" "io" "mantissa"];

  machines = [
    "desktop"
    "server"
    "elster"
    "blaidd-wsl"
    "money-machine-darwin"
  ];

  userMapping = with lib;
    mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "Username";
          };
          description = mkOption {
            type = types.str;
            description = "User description";
          };
        };
      });
      description = "Mapping of defined user attributes to private values";
      default = genAttrs users (username: {
        name = username;
        description = username;
      });
    };

  timezone = with lib;
    mkOption {
      type = types.str;
      description = "System timezone";
      default = "Etc/UTC";
    };

  cfg = config.vars;
in {
  options.vars =
    {
      common = {
        timezone = timezone;
        userMapping = userMapping;
      };
    }
    // lib.genAttrs machines (name: {
      hostname = lib.mkOption {
        type = lib.types.str;
        description = "System hostname";
        default = "nixos-${name}";
      };
      timezone = timezone // {default = cfg.common.timezone;};
      userMapping = userMapping // {default = cfg.common.userMapping;};
    });
}
