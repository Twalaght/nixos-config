{
  lib,
  myLib,
  dotfiles,
  config,
  name,
  system,
  ...
}: let
  homeBasePath = ".config/shell";
  basePath = "${dotfiles}/${homeBasePath}";

  cfg = config.homeSettings.shell;
in {
  options.homeSettings.shell = {
    enable = lib.mkEnableOption "Enable shell config";
    shell = lib.mkOption {
      type = lib.types.listOf (lib.types.enum ["zsh" "bash"]);
      default = ["zsh"];
      description = "Shells to set up config for";
    };
    fileOverrides = myLib.fileOverridesOption basePath;
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = lib.mkIf (builtins.elem "zsh" cfg.shell) {
      enable = true;
      enableCompletion = true;
      dotDir = "${config.xdg.configHome}/shell/zsh";

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

    programs.bash = lib.mkIf (builtins.elem "bash" cfg.shell) {
      enable = true;
      sessionVariables = {
        HOME_MANAGER_FLAKE_CONFIGURATION = "${name}-${system}";
      };
      profileExtra = ''
        [[ -f "$HOME/.config/shell/bash/.bashrc" ]] && source "$HOME/.config/shell/bash/.bashrc"
      '';
    };

    # Link dotfiles into home with any required overrides.
    home.file = myLib.mkFilesWithOverrides homeBasePath basePath cfg.fileOverrides;
  };
}
