{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ffmpeg
    gallery-dl
    imagemagick
  ];
}
