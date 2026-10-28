{ config, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
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
      reload = "source $ZDOTDIR/.zshrc && echo \".zshrc sourced!\"";
      "wttr" = "curl wttr.in | head -n -1";
      t25 = "termdown 25m";
      yayf = "yay -Slq | fzf --multi --preview 'paru -Sii {1}' --preview-window=down:75% | xargs -ro yay -S";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
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
}
