{ pkgs, inputs, ... }:

{
  # Communication & chat clients
  home.packages = with pkgs; [
    vesktop
    #signal-desktop
    #element-desktop
    inputs.cinny-electron.packages.${pkgs.stdenv.hostPlatform.system}.cinny-electron
    thunderbird
    #zoom-us
    #teamspeak6-client
  ];

  # Desktop entry in XDG_DATA_HOME so launchers (DMS spotlight) pick it up
  # even in an already-running session (the nix profile share dir is a
  # swapped symlink, which running launchers don't notice)
  xdg.dataFile."applications/cinny-electron.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Cinny
    GenericName=Matrix Client
    Comment=Electron wrapper around Cinny, yet another Matrix client
    Exec=cinny-electron %u
    Icon=cinny-electron
    Terminal=false
    Categories=Network;InstantMessaging;Chat
    MimeType=x-scheme-handler/matrix
    StartupWMClass=Cinny
  '';
}
