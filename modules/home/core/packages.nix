{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # General CLI Utilities
    ripgrep
    fd
    eza
    btop
    fastfetch
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
