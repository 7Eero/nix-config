{ config, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    sessionVariables = {
      NH_FLAKE = "$HOME/.config/nix-config";
    };
    envExtra = ''
      export NH_FLAKE="$HOME/.config/nix-config"
    '';

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
      reload = "[ -f $ZDOTDIR/.zshenv ] && source $ZDOTDIR/.zshenv; source $ZDOTDIR/.zshrc && echo \".zshrc sourced!\"";
      "wttr" = "curl wttr.in | head -n -1";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      nos = "nh os switch";
      nob = "nh os boot";
      not = "nh os test";
      nhh = "nh home switch";
      nhs = "nh search";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "python"
        "jj"
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

        # Check for Jujutsu first, then fall back to Git
        local jj_root=$(jj root --quiet 2> /dev/null)
        if [[ -n "$jj_root" ]]; then
          local jj_info=$(jj log --no-graph -r @ -T '
            change_id.shortest()
            ++ if(bookmarks, " (" ++ bookmarks.map(|b| b.name()).join(",") ++ ")")
            ++ if(conflict, "!", if(!empty, "*", ""))
          ' --no-pager --color never 2> /dev/null)
          if [[ "$jj_info" == *'!'* ]]; then
            echo -n "%F{1}"   # Red for conflicts
          elif [[ "$jj_info" == *'*'* ]]; then
            echo -n "%F{11}"  # Yellow for modified
          else
            echo -n "%F{10}"  # Green for clean
          fi
          echo -n "‹jj:''${jj_info}›%f"
        else
          local git_branch=$(git --no-optional-locks rev-parse --abbrev-ref HEAD 2> /dev/null)
          if [[ -n "$git_branch" ]]; then
            local git_status=$(git --no-optional-locks status --porcelain 2> /dev/null | tail -n 1)
            [[ -n "$git_status" ]] && echo -n "%F{11}" || echo -n "%F{10}"
            echo -n "‹''${git_branch}›%f"
          fi
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
