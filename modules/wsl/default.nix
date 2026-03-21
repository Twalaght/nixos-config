{...}: {
  imports = [
    ./docker.nix
  ];

  # Regsiter Windows executables.
  wsl.interop.register = true;
}
