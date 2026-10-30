{ pkgs, ... }:

{
  # OBS Studio with PipeWire audio capture plugin
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };

  # Audio, video, and creative desktop applications
  home.packages = with pkgs; [
    spotify
    #audacity
    #kdePackages.kdenlive
    komikku
    foliate
    imv
    mpv
  ];
}
