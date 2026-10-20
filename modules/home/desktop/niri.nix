{ pkgs, inputs, lib, ... }:

{
  # 1. Niri Wayland Compositor
  programs.niri = {
    package = pkgs.niri; # 26.4 — matches Arch host
    config = null;
  };

  xdg.configFile."niri/config.kdl".source = ../../../dotfiles/niri/config.kdl;
  xdg.configFile."DankMaterialShell/settings.json".source = ../../../dotfiles/DankMaterialShell/settings.json;

  # Ensure DMS include targets exist so Niri never throws missing-file errors on startup
  home.activation.setupNiriDms = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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

  # 2. DankMaterialShell, Quickshell & Compositor Helpers
  home.packages = with pkgs; [
    inputs.dankMaterialShell.packages.${pkgs.stdenv.hostPlatform.system}.default
    quickshell # provides both 'quickshell' and 'qs'
    matugen
    xwayland-satellite
  ];
}
