{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave-origin
    #tor-browser
  ];
}
