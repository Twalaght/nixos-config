{
  config,
  lib,
  pkgs,
  ...
}: let
  defineUser = import ./user-template.nix {inherit config lib pkgs;};
in
  defineUser {
    name = "io";
    opensshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGojf3bWewBs4X1C8l8xG2DQZD3jcCGoB02NPt3J/ztM"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP/j+TbND/PJ2Q2qMK+JfG8xgAbDozOY8S9h3ef0qozb"
    ];
  }
