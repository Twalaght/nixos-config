{lib, ...}: {
  imports = [
    ./git.nix
    ./homemanager.nix
    ./neovim.nix
    ./shell.nix
  ];

  homeSettings = {
    git.enable = lib.mkDefault true;
    homeManager.enable = lib.mkDefault true;
    neovim.enable = lib.mkDefault true;
    shell.enable = lib.mkDefault true;
  };
}
