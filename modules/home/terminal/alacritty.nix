{ ... }:

{
  # Alacritty configuration
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        import = [
          "~/.config/alacritty/dank-theme.toml"
        ];
        live_config_reload = true;
      };

      font = {
        size = 12.0;
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "SemiBold";
        };
        bold = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font Mono";
          style = "SemiBold Italic";
        };
      };

      window = {
        padding = {
          x = 12;
          y = 12;
        };
        opacity = 1.0;
      };

      terminal = {
        shell = {
          program = "zsh";
        };
      };
    };
  };
}
