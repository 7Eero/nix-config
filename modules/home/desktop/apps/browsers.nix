{ pkgs, ... }:

{
  # Web browsers
  programs.firefox = {
    enable = true;
  };

  home.packages = with pkgs; [
    brave-origin
    tor-browser
  ];
}
