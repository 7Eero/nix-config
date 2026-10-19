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
    bat
    jq
    ani-cli
    # Flake packages
    #inputs.dankMaterialShell.packages.${pkgs.stdenv.hostPlatform.system}.default
    #inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-ide

  ];

  # Niri configuration
  programs.niri = {
    enable = false;
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
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      append = true;
    };

    shellAliases = {
      ls = "eza --group-directories-first --icons=always";
      ll = "eza -al --icons=always";
      lt = "eza -a --tree --level=1 --icons=always";
      v = "nvim";
      c = "clear";
      bye = "shutdown -h now";
      neofetch = "fastfetch -c neofetch.jsonc --logo-type chafa -l ~/.config/fastfetch/img/pfp.jpg";
      reload = "source $HOME/.zshrc && echo \".zshrc sourced!\"";
      "sää" = "curl wttr.in/riihimäki | head -n -1";
      t25 = "termdown 25m";
      yayf = "yay -Slq | fzf --multi --preview 'paru -Sii {1}' --preview-window=down:75% | xargs -ro yay -S";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };

    initContent = ''
      export GTK_THEME="adw-gtk3-dark"
      export ADW_DEBUG_COLOR_SCHEME="prefer-dark"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export QT_QPA_PLATFORM=wayland
      export EDITOR=nvim
      export MANPAGER='nvim +Man!'

      # Oh My Zsh if present
      if [ -d "$HOME/.oh-my-zsh" ]; then
        export ZSH="$HOME/.oh-my-zsh"
        ZSH_THEME="aphrodite/aphrodite"
        plugins=(
          git
          archlinux
          zsh-autosuggestions
          zsh-syntax-highlighting
          thefuck
          python
        )
        source $ZSH/oh-my-zsh.sh
      fi

      source <(fzf --zsh)

      # NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

      function cdls() {
        chdir "$@"
        eza --group-directories-first --icons=always
      }

      # LM Studio CLI
      if [ -d "$HOME/.lmstudio/bin" ]; then
        export PATH="$PATH:$HOME/.lmstudio/bin"
      fi
    '';
  };

  # 3. Raw Symlinked Dotfiles (For tools without Nix modules)
  # xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/hyprland.conf;
}
