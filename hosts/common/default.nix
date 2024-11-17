# Common config to be shared and reusued among all hosts.
# Host specific config must be placed in the associated hosts file.
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../../modules
    inputs.home-manager.nixosModules.default
  ];

  # Enable flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Define system hostname.
  networking.hostName = "${config.host.hostname}";

  # Networking.
  networking.networkmanager.enable = true;
  # Configure network proxy if necessary.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = config.host.timezone;

  # Select localisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Configure console keymap.
  console.keyMap = "us";

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # List of packages installed in common profile.
  environment.systemPackages = with pkgs; [
    # Nix ecosystem
    alejandra
    sops
    statix

    # Standard server packages
    busybox
    git
    htop
    neofetch
    neovim
    pciutils
    stow
    wget
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
      "${config.default_user.username}" = import ../../modules/home-manager;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
