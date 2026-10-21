{ ... }:

{
  imports = [
    ./packages.nix
    ./session.nix
    ./git.nix
    ./btop.nix
    ./fastfetch.nix
  ];

  # Mandatory user options
  home.username = "eero";
  home.homeDirectory = "/home/eero";
  home.stateVersion = "26.05";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
