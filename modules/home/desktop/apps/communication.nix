{ pkgs, ... }:

{
  # Communication & chat clients
  home.packages = with pkgs; [
    vesktop          # Discord client with Vencord & Wayland screen sharing
    signal-desktop   # Signal private messenger
    element-desktop  # Matrix client
    cinny-desktop    # Lightweight Matrix client
    thunderbird      # Email & calendar client
    zoom-us          # Video conferencing
  ];
}
