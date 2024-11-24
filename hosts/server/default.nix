# Server specific config.
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../vars
    ./hardware-configuration.nix
    ../common
    inputs.home-manager.nixosModules.default
  ];

  # Set a variable such that the rebuild script remembers the target config.
  environment.variables = {
    NIXOS_SYSTEM_FLAKE_CONFIGURATION = "server";
  };

  # Enable home manager for the default user.
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "${config.default_user.username}" = import ../../modules/home-manager/desktop.nix;
    };
  };

  # Fix for virtual machine hardware passthrough.
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Open ports for web hosting.
  networking.firewall.allowedTCPPorts = [80 443];
  networking.firewall.allowedUDPPorts = [80 443];

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
