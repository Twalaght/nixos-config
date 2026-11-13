{config, ...}: {
  imports = [
    ../../modules
    ../../vars
  ];

  # Set the username and home directory for the user being managed.
  home = {
    username = config.vars.userMapping.mantissa.name;
    homeDirectory = "/home/${config.vars.userMapping.mantissa.name}";
  };

  homeSettings = {
    kitty.enable = true;
    vscode.enable = true;
  };

  home.stateVersion = "24.05";
}
