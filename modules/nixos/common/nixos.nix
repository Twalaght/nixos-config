{name, ...}: {
  # Enable flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set a variable such that the rebuild script remembers the target config.
  environment.variables = {
    NIXOS_SYSTEM_FLAKE_CONFIGURATION = name;
  };

  # Manage users imperatively after initial setup.
  users.mutableUsers = true;

  # Play nice with non-linux dual booted systems.
  time.hardwareClockInLocalTime = true;
}
