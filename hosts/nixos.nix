{ pkgs, inputs, ... }:

{
  imports = [ ../home.nix ];

  # 1. Niri Wayland Compositor (using exact config from Arch)
  programs.niri = {
    enable = true;
    config = null; # Allow relative DMS includes without build-time validator errors
  };

  xdg.configFile."niri/config.kdl".source = ../dotfiles/niri/config.kdl;

  # 2. DankMaterialShell & Theming Tools
  home.packages = with pkgs; [
    inputs.dankMaterialShell.packages.${pkgs.stdenv.hostPlatform.system}.default
    matugen
  ];

  # 3. Alacritty
  # Inherited from home.nix with identical fonts, padding, and dank-theme.toml import,
  # built with native GPU acceleration on NixOS.
}
