{...}: {
  imports = [
    ./autoupdate.nix
    ./bootloader.nix
    ./docker.nix
    ./sshd.nix
  ];
}
