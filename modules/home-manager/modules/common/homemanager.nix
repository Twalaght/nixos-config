{
  name,
  system,
  ...
}: {
  # Set a variable such that the rebuild script remembers the target config.
  home.sessionVariables = {
    HOME_MANAGER_FLAKE_CONFIGURATION = "${name}-${system}";
  };
}
