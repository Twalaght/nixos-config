{
  name,
  system,
  ...
}: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Set a variable such that the rebuild script remembers the target config.
  home.sessionVariables = {
    HOME_MANAGER_FLAKE_CONFIGURATION = "${name}-${system}";
  };

  # Hide the news alert when running home manager.
  news.display = "silent";
}
