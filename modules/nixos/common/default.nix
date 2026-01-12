{
  lib,
  config,
  ...
}: {
  imports = [
    ./autoupdate.nix
    ./docker.nix
    ./locale.nix
    ./networking.nix
    ./nixos.nix
    ./packages.nix
    ./python.nix
    ./security.nix
    ./ssh.nix
    ./sshd.nix
  ];

  systemSettings = {
    # Autoupdate
    autoupdate.enable = lib.mkDefault true;

    # Docker
    docker.enable = lib.mkDefault true;
    docker.users = lib.mkDefault [config.vars.user_mapping.mantissa.name];

    # Locale
    locale.enable = lib.mkDefault true;
    locale.timeZone = lib.mkDefault config.vars.host.timezone;
  };
}
