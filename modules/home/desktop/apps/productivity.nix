{ pkgs, ... }:

{
  # Productivity, documents, security, and utility applications
  home.packages = with pkgs; [
    obsidian                     # Markdown knowledge base & notes
    onlyoffice-desktopeditors    # Office productivity suite
    keepassxc                    # Password manager
    nextcloud-client             # File sync client
    thunar                       # Graphical file manager
    transmission_4-qt            # BitTorrent client
  ];
}
