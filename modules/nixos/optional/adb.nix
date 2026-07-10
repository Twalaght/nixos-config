# Android Debug Bridge and it's associated sync utility.
{
  lib,
  fetchFromGitHub,
  pkgs,
  config,
  myLib,
  ...
}: let
  better-adb-sync = pkgs.python3.pkgs.buildPythonApplication rec {
    pname = "better-adb-sync";
    version = "1.4.0";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "jb2170";
      repo = "better-adb-sync";
      rev = "v${version}";
      hash = "sha256-ghOpcnQEZiAEZOiVWhrHa66WgiyyYQZgTJEokJFKMRs=";
    };

    build-system = [
      pkgs.python3.pkgs.setuptools
    ];

    pythonImportsCheck = [
      "BetterADBSync"
    ];

    meta = {
      description = "Completely rewritten adbsync";
      homepage = "https://github.com/jb2170/better-adb-sync";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [];
      mainProgram = "better-adb-sync";
    };
  };
in {
  environment.systemPackages = with pkgs; [
    android-tools
    better-adb-sync
  ];

  # Add admin users to the adbsync group.
  users = myLib.generateUserGroups config.userInfo.admins ["adbsync"];
}
