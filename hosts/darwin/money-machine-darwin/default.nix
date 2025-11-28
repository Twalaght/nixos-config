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
    primaryUser = "${config.default_user.username}";
    defaults.NSGlobalDomain = {
      InitialKeyRepeat = 25;
      KeyRepeat = 2;
    };
  };
  security.pam.services.sudo_local.touchIdAuth = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
