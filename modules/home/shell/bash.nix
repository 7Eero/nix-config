{ ... }:

{
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
}
