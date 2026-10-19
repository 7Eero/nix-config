{ pkgs, inputs, lib, ... }:

{
  imports = [ ../home.nix ];

  # 1. Niri Wayland Compositor (using exact config from Arch)
  programs.niri = {
    enable = true;
    config = null;
  };

  xdg.configFile."niri/config.kdl".source = ../dotfiles/niri/config.kdl;

  # Ensure DMS include targets exist so Niri never throws missing-file errors on startup
  home.activation.setupNiriDms = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.config/niri/dms"
    for file in binds.kdl cursor.kdl windowrules.kdl outputs.kdl; do
      if [ ! -f "$HOME/.config/niri/dms/$file" ]; then
        $DRY_RUN_CMD touch "$HOME/.config/niri/dms/$file"
      fi
    done
  '';

  # 2. DankMaterialShell & Theming Tools
  home.packages = with pkgs; [
    inputs.dankMaterialShell.packages.${pkgs.stdenv.hostPlatform.system}.default
    matugen
  ];

  # 3. Alacritty
  # Inherited from home.nix with identical fonts, padding, and dank-theme.toml import,
  # built with native GPU acceleration on NixOS.
}
