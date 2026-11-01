{ ... }:

{
  # Alacritty configuration
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        live_config_reload = true;
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
