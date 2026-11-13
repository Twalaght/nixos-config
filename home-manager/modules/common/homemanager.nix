{
  config,
  lib,
  user,
  variant,
  system,
  ...
}: let
  cfg = config.homeSettings.homeManager;
in {
  options.homeSettings.homeManager = {
    enable = lib.mkEnableOption "Enable default home manager config";
  };

  config = lib.mkIf cfg.enable {
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Set a variable such that the rebuild script remembers the target config.
    home.sessionVariables = {
      HOME_MANAGER_FLAKE_CONFIGURATION = "${user}-${variant}-${system}";
    };

    # Hide the news alert when running home manager.
    news.display = "silent";
  };
}
