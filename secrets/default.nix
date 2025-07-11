# Enable and set up Sops.
{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = ["/home/${config.default_user.username}/.ssh/nixos_sops"];
  };
}
