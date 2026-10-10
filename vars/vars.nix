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
in
  with lib; {
    options.vars =
      {
        # TODO - Deprecated, replaced by common and per-host user mapping.
        user_mapping = userMapping;

        common = {
          userMapping = userMapping;
          timezone = timezone;
        };
      }
      // lib.genAttrs machines (name: {
        hostname = mkOption {
          type = types.str;
          description = "System hostname";
          default = "nixos-${name}";
        };
        timezone = timezone // {default = cfg.common.timezone;};

        userMapping = userMapping // {default = cfg.common.userMapping;};
      })
      // {
        # TODO - Deprecated, replaced by per system block
        host = {
          hostname = mkOption {
            type = types.str;
            description = "System hostname";
            default = "nixos-${name}";
          };
          timezone = timezone;
        };
      };
  }
