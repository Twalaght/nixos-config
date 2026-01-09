{lib, ...}:
with lib; {
  options.vars.host = {
    hostname = mkOption {
      type = types.str;
      description = "System hostname";
      default = "nixos";
    };
    timezone = mkOption {
      type = types.str;
      description = "System timezone";
      default = "Etc/UTC";
    };
  };

  options.vars = {
    user_mapping = mkOption {
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
      default = lib.genAttrs ["io" "mantissa"] (username: {
        name = username;
        description = username;
      });
    };
  };
}
