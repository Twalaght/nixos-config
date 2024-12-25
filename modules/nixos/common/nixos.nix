{...}: {
  # Enable flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Manage users imperatively after initial setup.
  users.mutableUsers = true;

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;
}
