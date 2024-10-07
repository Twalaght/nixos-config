{lib, ...}:
with lib; {
  options.default_user = {
    username = mkOption {
      type = types.str;
      description = "Primary account username";
      default = "nixos";
    };
    description = mkOption {
      type = types.str;
      description = "Primary account user description";
      default = "nixos user";
    };
  };

  options.host = {
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
}
