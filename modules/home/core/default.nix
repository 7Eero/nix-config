{ ... }:

{
  imports = [
    ./packages.nix
    ./session.nix
    ./git.nix
    ./btop.nix
    ./fastfetch.nix
    ./jj.nix
  ];

  # Mandatory user options
  home.username = "eero";
  home.homeDirectory = "/home/eero";
  home.stateVersion = "26.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
