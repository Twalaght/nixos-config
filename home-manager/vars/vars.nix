{lib, ...}: let
  users = ["glorp" "io" "mantissa"];
in {
  options.vars.userMapping = with lib;
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
}
