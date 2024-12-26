{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = true;

    # Extensions
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
    ];

    # Settings
    userSettings = {
      # General
      "editor.fontSize" = 20;
      "editor.fontFamily" = "'Jetbrains Mono', 'monospace', monospace";
    };
  };
}
