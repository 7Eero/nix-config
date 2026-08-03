{ pkgs, inputs, ... }:

{
  # Mandatory options
  home.username = "eero"; # Replace with your actual Arch username
  home.homeDirectory = "/home/eero";
  home.stateVersion = "26.05"; # Match current release version

  # Crucial for non-NixOS Linux (sets up XDG vars, fonts, desktop files)
  targets.genericLinux.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # 1. User Packages (Replaces pacman for user tools)
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
    ani-cli
    bat
    jq

    # Flake packages
    inputs.dankMaterialShell.packages.${pkgs.system}.default
    inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-ide
  ];

  # Niri configuration
  programs.niri = {
    enable = true;
  };

  # 2. Native Nix-Managed Programs
  programs.git = {
    enable = true;
    settings = {
      user.name = "7Eero";
      user.email = "eero@cyberbullying.club";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "eza -l";
    };
  };

  # 3. Raw Symlinked Dotfiles (For tools without Nix modules)
  # xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/hyprland.conf;
}