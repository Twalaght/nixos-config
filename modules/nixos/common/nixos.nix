{...}: {
  # Enable flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Manage users imperatively after initial setup.
  users.mutableUsers = true;

  # Play nice with non-linux dual booted systems.
  time.hardwareClockInLocalTime = true;
}
