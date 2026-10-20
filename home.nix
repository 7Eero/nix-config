{ pkgs, inputs, ... }:

{
  # Mandatory options
  home.username = "eero"; # Replace with your actual Arch username
  home.homeDirectory = "/home/eero";
  home.stateVersion = "26.05"; # Match current release version

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Session environment variables (propagated to shells, systemd --user, and Wayland sessions)
  home.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
    ADW_DEBUG_COLOR_SCHEME = "prefer-dark";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_QPA_PLATFORM = "wayland";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  # User service to ensure Home Manager session and environment are loaded on login (for Arch & standalone)
  systemd.user.services.home-manager-ensure = {
    Unit = {
      Description = "Ensure Home Manager environment is active on login";
      Documentation = [ "https://github.com/nix-community/home-manager" ];
      After = [ "basic.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.writeShellScript "hm-ensure-env" ''
        if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
          . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
          ${pkgs.systemd}/bin/systemctl --user import-environment PATH XDG_DATA_DIRS GTK_THEME QT_QPA_PLATFORM EDITOR
          if command -v dbus-update-activation-environment >/dev/null 2>&1; then
            dbus-update-activation-environment --systemd PATH XDG_DATA_DIRS GTK_THEME QT_QPA_PLATFORM EDITOR
          fi
        fi
      ''}";
    };
  };

  # Automatically start / restart systemd user units on activation
  systemd.user.startServices = "sd-switch";

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
    fzf
  ];


  # Alacritty configuration
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        import = [
          "~/.config/alacritty/dank-theme.toml"
        ];
        live_config_reload = true;
      };

      font = {
        size = 12.0;
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "SemiBold";
        };
        bold = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font Mono";
          style = "SemiBold Italic";
        };
      };

      window = {
        padding = {
          x = 12;
          y = 12;
        };
        opacity = 1.0;
      };

      terminal = {
        shell = {
          program = "zsh";
        };
      };
    };
  };

  # 2. Native Nix-Managed Programs
  programs.bash = {
    enable = true;
    initExtra = ''
      # If running an interactive shell and not already in Zsh, exec into Zsh
      if [[ $- == *i* ]] && [ -z "$BASH_EXEC_ZSH" ] && [ "$SHELL" != *"zsh"* ]; then
        export BASH_EXEC_ZSH=1
        exec zsh
      fi
    '';
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "7Eero";
      user.email = "126098783+7Eero@users.noreply.github.com";
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
      "wttr" = "curl wttr.in | head -n -1";
      t25 = "termdown 25m";
      yayf = "yay -Slq | fzf --multi --preview 'paru -Sii {1}' --preview-window=down:75% | xargs -ro yay -S";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "hm-switch" = "sudo nixos-rebuild switch --flake ~/.config/nix-config#nixos";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "python"
      ];
    };

    initContent = ''
      # Aphrodite Theme (Embedded so it works out of the box on NixOS and Arch)
      export VIRTUAL_ENV_DISABLE_PROMPT=true
      setopt PROMPT_SUBST

      aphrodite_get_prompt() {
        if [[ -v VIRTUAL_ENV ]]; then
          echo -n "%F{7}["$(basename "$VIRTUAL_ENV")"]%f "
        fi

        echo -n "%F{6}%n"
        echo -n "%F{8}@"
        echo -n "%F{12}%m"
        echo -n "%F{8}:"
        echo -n "%f%~"
        echo -n " "

        local git_branch=$(git --no-optional-locks rev-parse --abbrev-ref HEAD 2> /dev/null)
        if [[ -n "$git_branch" ]]; then
          local git_status=$(git --no-optional-locks status --porcelain 2> /dev/null | tail -n 1)
          [[ -n "$git_status" ]] && echo -n "%F{11}" || echo -n "%F{10}"
          echo -n "‹''${git_branch}›%f"
        fi

        if [[ -v APHRODITE_THEME_SHOW_TIME ]]; then
          echo -n "%F{8} [%D{%H:%M:%S}]%f"
        fi

        echo

        echo -n "%(?.%f.%F{1})"
        echo -n "%(!.#.$)%f "
      }

      export PROMPT='$(aphrodite_get_prompt)'

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
