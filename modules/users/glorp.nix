{
  config,
  lib,
  pkgs,
  systemName,
  ...
}: let
  defineUser = import ./user-template.nix {inherit config lib pkgs systemName;};
in
  defineUser {
    name = "glorp";
    admin = false;
    noPassword = true;
  }
