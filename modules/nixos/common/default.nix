{...}: {
  imports = [
    ./autoupdate.nix
    ./docker.nix
    ./locale.nix
    ./networking.nix
    ./nixos.nix
    ./packages.nix
    ./sshd.nix
  ];
}