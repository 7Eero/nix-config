{ pkgs, lib, ... }:

{
  # EasyEffects daemon service
  services.easyeffects = {
    enable = true;
  };

  # Ensure EasyEffects restarts automatically if it crashes or PipeWire resets
  systemd.user.services.easyeffects = {
    Unit = {
      After = [ "pipewire.service" ];
      PartOf = [ "pipewire.service" ];
    };
    Service = {
      Restart = lib.mkForce "always";
    };
  };
}
