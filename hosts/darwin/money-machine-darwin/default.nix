{
  self,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../../vars
  ];

  environment.systemPackages = with pkgs; [
    bat
    htop
    vim
  ];

  nix.settings.experimental-features = "nix-command flakes";

  system = {
    primaryUser = config.vars.user_mapping.mantissa.name;
    defaults.NSGlobalDomain = {
      InitialKeyRepeat = 25;
      KeyRepeat = 2;
    };
  };
  security.pam.services.sudo_local.touchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
