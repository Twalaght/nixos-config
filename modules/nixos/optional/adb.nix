# Android Debug Bridge and the ADBSync utility.
{
  lib,
  fetchFromGitHub,
  pkgs,
  config,
  myLib,
  ...
}: let
  cfg = config.systemSettings.adb;

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
  options.systemSettings.adb = {
    enable = lib.mkEnableOption "Enable Android Debug Bridge and ADBSync";
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Users to add to the adbsync group";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      android-tools
      better-adb-sync
    ];

    # Add users to the adbsync group.
    users = myLib.generateUserGroups cfg.users ["adbsync"];
  };
}
