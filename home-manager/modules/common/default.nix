{lib, ...}: {
  imports = [
    ./git.nix
    ./homemanager.nix
    ./neovim.nix
    ./shell.nix
  ];

  homeSettings = {
    # Shell
    shell.enable = lib.mkDefault true;
    shell.shell = ["zsh" "bash"];
  };
}
