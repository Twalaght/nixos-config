{...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Twalaght";
        email = "52785900+Twalaght@users.noreply.github.com";
      };
      push.autoSetupRemote = true;
      advice.skippedCherryPicks = "false";
    };
  };
}
