{
  config,
  lib,
  dotfiles,
  ...
}: let
  cfg = config.homeSettings.neovim;
in {
  options.homeSettings.neovim = {
    enable = lib.mkEnableOption "Enable neovim config";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      sideloadInitLua = true;
    };

    xdg = {
      configFile."nvim/init.vim" = {
        source = "${dotfiles}/.config/nvim/init.vim";
      };
    };
  };
}
