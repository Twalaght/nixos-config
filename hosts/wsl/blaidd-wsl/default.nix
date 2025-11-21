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
  ];

  # Set a variable such that the rebuild script remembers the target config.
  environment.variables = {
    NIXOS_SYSTEM_FLAKE_CONFIGURATION = "blaidd-wsl";
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  wsl = {
    enable = true;
    defaultUser = "${config.default_user.username}";
    wslConf.automount.options = "metadata";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
