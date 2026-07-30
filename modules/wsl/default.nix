{...}: {
  imports = [
    ./docker.nix
  ];

  # Register Windows executables.
  wsl.interop.register = true;
}
