{ ... }:

{
  imports = [ ../home.nix ];

  # On NixOS:
  # - targets.genericLinux is NOT needed (NixOS manages XDG and system integration natively)
  # - programs.alacritty uses pkgs.alacritty automatically with native hardware acceleration
}
