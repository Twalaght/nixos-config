{
  config,
  lib,
  pkgs,
  ...
}: let
  defineUser = import ./user-template.nix {inherit config lib pkgs;};
in
  defineUser {
    name = "glorp";
    admin = false;
    noPassword = true;
  }
