{ pkgs, ... }:

{
  # Steam, micro-compositor, game performance daemon, and Proton utility tools
  home.packages = with pkgs; [
    steam
    protontricks
    gamescope
    gamemode
  ];
}
