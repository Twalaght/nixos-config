{config, ...}: {
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

  systemSettings.docker.enable = true;
  systemSettings.docker.users = [config.vars.user_mapping.mantissa.name];
}
