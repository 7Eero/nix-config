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
}
