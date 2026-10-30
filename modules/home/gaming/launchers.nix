{ pkgs, ... }:

{
  # Game launchers, Wine runtime, and gaming hardware configuration
  home.packages = with pkgs; [
    #lutris
    prismlauncher
    wineWow64Packages.waylandFull
    winetricks
  ];
}
