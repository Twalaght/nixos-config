{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    zplug = {
      enable = true;
      plugins = [
        {name = "zsh-users/zsh-autosuggestions";}
      ];
    };
  };
}
