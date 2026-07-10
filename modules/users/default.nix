{
  config,
  lib,
  ...
}: {
  imports = [
    ./io.nix
    ./mantissa.nix
  ];

  options.userInfo.admins = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "List of enabled admin usernames.";
  };
}
