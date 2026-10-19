{ pkgs, inputs, lib, ... }:

{
  imports = [ ../home.nix ];

  # 1. Niri Wayland Compositor (using exact config from Arch)
  programs.niri = {
    enable = true;
    package = pkgs.niri; # Niri 26.04 (matches Arch 26.04 series)
    config = null;
  };

  xdg.configFile."niri/config.kdl".source = ../dotfiles/niri/config.kdl;
  xdg.configFile."DankMaterialShell/settings.json".source = ../dotfiles/DankMaterialShell/settings.json;

  # Ensure DMS include targets exist so Niri never throws missing-file errors on startup
  home.activation.setupNiriDms = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.config/niri/dms"
    for file in binds.kdl windowrules.kdl outputs.kdl; do
      if [ ! -f "$HOME/.config/niri/dms/$file" ]; then
        $DRY_RUN_CMD touch "$HOME/.config/niri/dms/$file"
      fi
    done
    if [ ! -s "$HOME/.config/niri/dms/cursor.kdl" ]; then
      cat << 'EOF' > "$HOME/.config/niri/dms/cursor.kdl"
cursor {
    xcursor-theme "Bibata-Modern-Ice"
    xcursor-size 24
}
EOF
    fi
  '';

  # 2. DankMaterialShell, Quickshell & Theming Tools
  home.packages = with pkgs; [
    inputs.dankMaterialShell.packages.${pkgs.stdenv.hostPlatform.system}.default
    quickshell # provides both 'quickshell' and 'qs'
    matugen
    keepassxc
    nextcloud-client
    xwayland-satellite
    # User Applications
    brave-origin
    vscode
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-ide
  ];

  # 3. Cursor & Icon Theming
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
    iconTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = "Bibata-Modern-Ice";
      cursor-size = 24;
      icon-theme = "Bibata-Modern-Ice";
    };
  };

  # 4. Alacritty
  # Inherited from home.nix with identical fonts, padding, and dank-theme.toml import,
  # built with native GPU acceleration on NixOS.
}
