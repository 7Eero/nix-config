{ pkgs, ... }:

{
  # Communication & chat clients
  home.packages = with pkgs; [
    vesktop
    #signal-desktop
    #element-desktop
    #cinny-desktop
    thunderbird
    #zoom-us
  ];
}
