{config, lib, dotfiles, pkgs, ...}: {
  imports = [
    ../../vars
    ../../modules/common/homemanager.nix
    ../../modules/common/shell.nix
    ../../modules/common/neovim.nix
  ];

  # Set the username and home directory for the user being managed.
  home = {
    username = config.vars.user_mapping.mantissa.name;
    homeDirectory = "/Users/${config.vars.user_mapping.mantissa.name}";
  };

  homeSettings = {
    # Shell
    shell.enable = lib.mkDefault true;
    shell.fileOverrides = [
      {
          relativePath = "zsh/.zshrc";
          content = (builtins.readFile "${dotfiles}/.config/shell/zsh/.zshrc") + ''
            # MacOS or iTerm gets weird if this isn't defined last
            bindkey "^ " autosuggest-accept

            # Load work specific shell config
            [[ -f "$HOME/.config/shell/workrc" ]] && source "$HOME/.config/shell/workrc"
          '';
          force = false;
      }
    ];
  };

  home.stateVersion = "26.05";
}
