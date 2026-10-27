{ config, lib, ... }:

{
  imports = [
    ../../modules/home/core
    ../../modules/home/shell
    ../../modules/home/terminal/alacritty.nix
    ../../modules/home/desktop
    ../../modules/home/gaming
  ];

  xdg.configFile."niri/config.kdl".source =
    lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-config/dotfiles/niri/config.kdl");
  xdg.configFile."DankMaterialShell/settings.json".source =
    lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-config/dotfiles/DankMaterialShell/settings.json");
}
