{
  pkgs,
  dotfiles,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = ".config/shell/zsh";

    zplug = {
      enable = true;
      plugins = [
        {name = "zsh-users/zsh-autosuggestions";}
      ];
    };
  };

  # Link dotfiles into .config.
  home.file.".config/shell".source = "${dotfiles}/.config/shell";
  home.file.".config/shell".recursive = true;
}
