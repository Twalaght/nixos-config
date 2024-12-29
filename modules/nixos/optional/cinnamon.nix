# Enable the Cinnamon desktop environment.
{...}: {
  services = {
    libinput.enable = true;
    displayManager.defaultSession = "cinnamon";
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager = {
        cinnamon.enable = true;
      };
    };
  };
}
