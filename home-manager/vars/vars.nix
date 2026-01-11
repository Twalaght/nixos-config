{lib, ...}:
with lib; {
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
      default = lib.genAttrs ["mantissa"] (username: {
        name = username;
      });
    };
  };
}
