{
  systemType,
  lib,
  ...
}: {
  imports =
    [
      ./nixos
      ./users
    ]
    ++ lib.optional (systemType == "wsl") ./wsl;
}
