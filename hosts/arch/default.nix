{ ... }:

{
  imports = [
    ../../modules/home/core
    ../../modules/home/shell
    ../../modules/home/terminal/alacritty.nix
    ../../modules/home/desktop/theme.nix
  ];

  # Arch Linux / generic Linux specific: sets up XDG dirs, desktop entries, and GPU bridge
  targets.genericLinux.enable = true;

  # Use native Arch pacman binary for Alacritty to integrate directly with host GPU & Wayland
  programs.alacritty.package = null;

  # Niri is installed and managed via pacman (niri-git) on Arch
  programs.niri.enable = false;
}
