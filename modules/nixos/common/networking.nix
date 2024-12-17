{config, ...}: {
  # Define system hostname.
  networking.hostName = "${config.host.hostname}";

  # Networking.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
