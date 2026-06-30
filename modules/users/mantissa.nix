{
  config,
  lib,
  pkgs,
  ...
}: let
  defineUser = import ./user-template.nix {inherit config lib pkgs;};
in
  defineUser {
    name = "mantissa";
    opensshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/RgCQjdF6x7t0fNFAnhSUDLiyrVtez62MLBo6Kf3J+"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfpDJbb+8RoCjec6dD0k1YzXqLlHrn5yx5cI3UXIyyV"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5fORGIpVoiY5OTqPXYypWgrky1V3PqX9qry0kkjAWk"
    ];
  }
