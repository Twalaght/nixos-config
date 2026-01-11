{config, ...}: {
  imports = [
    ../../vars
    ../../modules/common
    ../../modules/optional/kitty.nix
    ../../modules/optional/vscode.nix
  ];

  # Set the username and home directory for the user being managed.
  home = {
    username = config.vars.user_mapping.mantissa.name;
    homeDirectory = "/home/${config.vars.user_mapping.mantissa.name}";
  };

  home.stateVersion = "24.05";
}
