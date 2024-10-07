{lib, ...}: {
  imports =
    [
      ./vars.nix
    ]
    ++ lib.optional (builtins.pathExists ./config.nix) ./config.nix;
}
