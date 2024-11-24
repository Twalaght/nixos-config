{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  # Enable zsh for the users default shell.
  environment.systemPackages = with pkgs; [
    zsh
  ];

  # Manage users imperatively after initial setup.
  users.mutableUsers = true;

  # Define a primary user account. Set the password after creation with `passwd`.
  users.users.${config.default_user.username} = {
    isNormalUser = true;
    description = "${config.default_user.description}";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    initialHashedPassword = "$2b$12$o7hI24c80QPDTq0WUepU1.EqvJQM27z8/HGYynacFccjjTb23mdJS";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/RgCQjdF6x7t0fNFAnhSUDLiyrVtez62MLBo6Kf3J+"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfpDJbb+8RoCjec6dD0k1YzXqLlHrn5yx5cI3UXIyyV"
    ];
  };
  programs.zsh.enable = true;

  # Enable home manager for the default user.
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "${config.default_user.username}" = import ../../modules/home-manager/desktop.nix;
    };
  };
}
