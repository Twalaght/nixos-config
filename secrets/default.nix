# Enable and set up Sops.
{
  config,
  inputs,
  systemName,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = ["/home/${config.users.mantissa.username}/.ssh/nixos_sops"];
  };
}
