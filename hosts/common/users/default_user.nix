{
  config,
  inputs,
  pkgs,
  ...
}: {
  # Define a primary user account. Set the password after creation with `passwd`.
  users.users.${config.default_user.username} = {
    isNormalUser = true;
    description = "${config.default_user.description}";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    initialHashedPassword = "$2b$12$OYdcZxJ36JbTLIs5mHa45eXkJGinnFgHBmo2.t9FqAEhEyeg3yqA2";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/RgCQjdF6x7t0fNFAnhSUDLiyrVtez62MLBo6Kf3J+"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfpDJbb+8RoCjec6dD0k1YzXqLlHrn5yx5cI3UXIyyV"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5fORGIpVoiY5OTqPXYypWgrky1V3PqX9qry0kkjAWk"
    ];
  };
  programs.zsh.enable = true;
}
