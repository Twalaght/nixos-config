{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../../../vars

    ../../common/users/default-user.nix
    ../../../modules/nixos/common
    ../../../modules/nixos/optional/desktop-cli.nix
    ../../../modules/wsl
  ];

  wsl = {
    enable = true;
    defaultUser = "${config.default_user.username}";
    wslConf.automount.options = "metadata";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
