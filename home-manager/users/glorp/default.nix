{
  lib,
  config,
  ...
}: {
  imports = [
    ../../vars
  ];

  # Set the username and home directory for the user being managed.
  home = {
    username = "glorp";
    homeDirectory = "/home/glorp";
  };

  # Create a custom Steam launcher with Big Picture Mode flags
  xdg.desktopEntries = {
    "steam-bigpicture" = {
      name = "Steam (Big Picture)";
      # -gamepadui triggers the modern Steam Deck style Big Picture Mode
      exec = "steam -gamepadui %U";
      icon = "steam";
      type = "Application";
      terminal = false;
      categories = ["Network" "FileTransfer" "Game"];
      mimeType = ["x-scheme-handler/steam" "x-scheme-handler/steamlink"];
    };
  };

  programs.plasma = {
    enable = true;

    # Target the KActivityManagerd database where favorites are stored
    configFile = let
      # List your exact .desktop applications here
      favoriteApps = [
        "applications:steam-bigpicture.desktop"
        "applications:com.moonlight_stream.Moonlight.desktop"
        "applications:freetube.desktop"
      ];
    in {
      "kactivitymanagerd-statsrc" = {
        "Favorites-org.kde.plasma.kickoff.favorites.instance-3-global" = {
          ordering = lib.concatStringsSep "," favoriteApps;
        };
      };
    };
  };

  home.stateVersion = "26.05";
}
