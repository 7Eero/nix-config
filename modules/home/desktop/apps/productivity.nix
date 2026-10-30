{ pkgs, ... }:

{
  # Productivity, documents, security, and utility applications
  home.packages = with pkgs; [
    #obsidian 
    onlyoffice-desktopeditors
    keepassxc
    nextcloud-client
    thunar                       
    transmission_4-qt
  ];
}
