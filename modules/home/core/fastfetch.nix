{ ... }:

{
  programs.fastfetch.enable = true;

  # Link fastfetch config and profile picture
  xdg.configFile."fastfetch".source = ../../../dotfiles/fastfetch;
}
