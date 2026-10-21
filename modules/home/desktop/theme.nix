{ pkgs, ... }:

{
  # Cursor Theming
  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    XCURSOR_PATH = "$HOME/.local/share/icons:$HOME/.icons:$HOME/.nix-profile/share/icons:/usr/share/icons:/usr/share/pixmaps";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = "Bibata-Modern-Ice";
      cursor-size = 24;
    };
  };
}
