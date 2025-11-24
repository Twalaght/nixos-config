{config, ...}: {
  imports = [
    ../../vars
    ../../modules/common
    ../../modules/optional/kitty.nix
    ../../modules/optional/vscode.nix
  ];

  # Set the username and home directory for the user being managed.
  home = {
    username = "${config.default_user.username}";
    homeDirectory = "/home/${config.default_user.username}";
  };

  home.stateVersion = "24.05";
}
