{ ... }:

{
  # MangoHud configuration overlay
  # Config is written to ~/.config/MangoHud/MangoHud.conf
  programs.mangohud = {
    enable = true;
    settings = {
      # Hidden by default; toggle overlay in-game with hotkey (default: Right Shift + F12)
      no_display = true;
    };
  };
}
