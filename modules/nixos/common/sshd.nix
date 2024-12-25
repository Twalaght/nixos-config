{
  config,
  pkgs,
  ...
}: {
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;

    # Enforce public key authentication and forbid root logins.
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Open SSH access.
  networking.firewall.allowedTCPPorts = [22];
  networking.firewall.allowedUDPPorts = [22];
}
