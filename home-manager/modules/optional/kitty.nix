{lib, ...}: {
  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      confirm_os_window_close = "0";
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = "10";
      background_opacity = "0.95";
      background_blur = "5";

      tab_title_template = "{index}";

      font_family = "monospace";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = "20.0";

      # Gruvbox colour theme.
      selection_foreground = "#ebdbb2";
      selection_background = "#d65d0e";
      background = "#1d2021";
      foreground = "#ebdbb2";
      color0 = "#3c3836";
      color1 = "#cc241d";
      color2 = "#98971a";
      color3 = "#d79921";
      color4 = "#458588";
      color5 = "#b16286";
      color6 = "#689d6a";
      color7 = "#a89984";
      color8 = "#928374";
      color9 = "#fb4934";
      color10 = "#b8bb26";
      color11 = "#fabd2f";
      color12 = "#83a598";
      color13 = "#d3869b";
      color14 = "#8ec07c";
      color15 = "#fbf1c7";
      cursor = "#bdae93";
      cursor_text_color = "#665c54";
      url_color = "#458588";
    };
  };
}
