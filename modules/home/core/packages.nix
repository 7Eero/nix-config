{ pkgs, ... }:

let
  ani-cli = pkgs.ani-cli.overrideAttrs (old: rec {
    version = "5.1";
    src = pkgs.fetchFromGitHub {
      owner = "pystardust";
      repo = "ani-cli";
      tag = "v${version}";
      hash = "sha256-lPQA3iO3F/9NS2IziQccsJ3aai6WMQy6YObdB3mDCZA=";
    };
  });
in
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
