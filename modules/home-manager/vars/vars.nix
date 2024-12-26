{lib, ...}:
with lib; {
  options.default_user = {
    username = mkOption {
      type = types.str;
      description = "Primary account username";
      default = "nixos";
    };
  };
}
