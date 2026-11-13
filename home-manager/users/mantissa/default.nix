{config, ...}: {
  imports = [
    ../../vars
    ../../modules/common
  ];

  # Set the username and home directory for the user being managed.
  home = {
    username = config.vars.userMapping.mantissa.name;
    homeDirectory = "/home/${config.vars.userMapping.mantissa.name}";
  };

  home.stateVersion = "26.05";
}
