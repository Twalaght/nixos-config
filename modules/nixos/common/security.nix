{...}: {
  # Extend the default sudo timeout to 60 minutes.
  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=60
  '';
}
