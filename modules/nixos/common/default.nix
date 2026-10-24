{lib, ...}: {
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
    docker.enable = lib.mkDefault true;
    locale.enable = lib.mkDefault true;
    networking.enable = lib.mkDefault true;
    nixos.enable = lib.mkDefault true;
    packages.common.enable = lib.mkDefault true;
    python.enable = lib.mkDefault true;
    security.enable = lib.mkDefault true;
    sshd.enable = lib.mkDefault true;
  };
}
