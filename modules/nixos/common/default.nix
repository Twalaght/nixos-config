{
  lib,
  config,
  ...
}: {
  imports = [
    ./docker.nix
    ./locale.nix
    ./networking.nix
    ./nixos.nix
    ./packages.nix
    ./python.nix
    ./security.nix
    ./sshd.nix
  ];

  systemSettings = {
    # Docker
    docker = {
      enable = lib.mkDefault true;
      users = lib.mkDefault config.userInfo.admins;
    };

    # Locale
    locale = {
      enable = lib.mkDefault true;
      timeZone = lib.mkDefault config.vars.host.timezone;
    };

    # Networking
    networking = {
      enable = lib.mkDefault true;
      hostname = lib.mkDefault config.vars.host.hostname;
    };

    # NixOS
    nixos = {
      enable = lib.mkDefault true;
      downloadBuffer = lib.mkDefault 512;
      hardwareClockInLocalTime = lib.mkDefault true;
    };

    # Packages
    packages.enable = lib.mkDefault true;

    # Python
    python.enable = lib.mkDefault true;

    # Security
    security = {
      enable = lib.mkDefault true;
      sudoTimeout = lib.mkDefault 60;
    };

    # SSHD
    sshd.enable = lib.mkDefault true;
  };
}
