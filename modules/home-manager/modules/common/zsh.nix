{
  pkgs,
  dotfiles,
  name,
  system,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = ".config/shell/zsh";

    # Ensure Zsh has the flake config set, as it can be unreliable with the dotfiles setup.
    envExtra = ''
      export HOME_MANAGER_FLAKE_CONFIGURATION="${name}-${system}";
    '';

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
