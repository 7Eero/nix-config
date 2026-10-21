{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # General CLI Utilities
    ripgrep
    fd
    eza
    gallery-dl
    termdown
    neovim
    yazi
    tealdeer
    yt-dlp
    git-lfs
    bat
    jq
    ani-cli
    fzf
  ];
}
