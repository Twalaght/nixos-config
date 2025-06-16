{
  pkgs,
  pkgs-unstable,
  config,
  vscode-extensions,
  ...
}: rec {
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;

    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = true;

    extensions = with vscode-extensions.vscode-marketplace; [
      # General
      streetsidesoftware.code-spell-checker

      # File operations
      clemenspeters.format-json
      html-validate.vscode-html-validate
      janisdd.vscode-edit-csv
      mechatroner.rainbow-csv
      pascalreitermann93.vscode-yaml-sort
      pkief.material-icon-theme
      redhat.vscode-yaml
      tamasfe.even-better-toml

      # Vim
      slhsxcmy.vscode-double-line-numbers
      vscodevim.vim

      # Themes
      jdinhlife.gruvbox

      # Python centric
      ms-python.python
      ms-python.debugpy
      ms-python.vscode-pylance
      njpwerner.autodocstring
    ];

    userSettings = {
      "workbench.colorTheme" = "Gruvbox Dark Hard";
      "vim.handleKeys" = {
        "<C-f>" = false;
      };
      "editor.insertSpaces" = true;
      "workbench.iconTheme" = "material-icon-theme";
      "material-icon-theme.folders.theme" = "classic";
      "[python]" = {
        "editor.formatOnType" = true;
      };
      "workbench.tree.indent" = 16;
      "cSpell.language" = "en,en-GB";
      "editor.glyphMargin" = true;
      "editor.semanticHighlighting.enabled" = false;
      "files.autoSave" = "afterDelay";
    };

    keybindings = [
      # Quickswitch into terminal
      {
        key = "cmd+down";
        command = "workbench.action.terminal.focus";
      }
      {
        key = "cmd+up";
        command = "workbench.action.focusActiveEditorGroup";
        when = "terminalFocus";
      }
      {
        key = "ctrl+j";
        command = "workbench.action.terminal.focus";
      }
      {
        key = "ctrl+k";
        command = "workbench.action.focusActiveEditorGroup";
        when = "terminalFocus";
      }

      # Quickswitch open files
      {
        key = "ctrl+l";
        command = "extension.vim_ctrl+pagedown";
        when = "editorTextFocus && vim.active && vim.use<C-pagedown> && !inDebugRepl";
      }
      {
        key = "ctrl+h";
        command = "extension.vim_ctrl+pageup";
        when = "editorTextFocus && vim.active && vim.use<C-pageup> && !inDebugRepl";
      }

      # Move lines in place
      {
        key = "alt+j";
        command = "editor.action.moveLinesDownAction";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "alt+k";
        command = "editor.action.moveLinesUpAction";
        when = "editorTextFocus && !editorReadonly";
      }
    ];
  };

  # VSCode attempts to write state to the user's immutable `settings.json` file.
  # This resolves the link at activation time, and cleans it up when rebuilding.
  home.activation = let
    configDirName =
      {
        "vscode" = "Code";
        "vscode-insiders" = "Code - Insiders";
        "vscodium" = "VSCodium";
      }
      .${
        programs.vscode.package.pname
      };
    configPath = "${config.xdg.configHome}/${configDirName}/User/settings.json";
  in {
    clearExistingVSCodeConfig = {
      after = [];
      before = ["checkLinkTargets"];
      data = ''
        rm -rf ${configPath}
      '';
    };

    makeVSCodeConfigWritable = {
      after = ["writeBoundary"];
      before = [];
      data = ''
        install -m 0640 "$(readlink ${configPath})" ${configPath}
      '';
    };
  };
}
