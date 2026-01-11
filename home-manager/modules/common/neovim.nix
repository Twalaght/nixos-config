{
  pkgs,
  dotfiles,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  xdg = {
    configFile."nvim/init.vim" = {
      source = "${dotfiles}/.config/nvim/init.vim";
    };
  };
}
