{ config, pkgs, lib, ... }:

let
  cfg = config.modules.desktop.audio;
in
{
  options.modules.desktop.audio = {
    enable = lib.mkEnableOption "desktop audio configuration" // { default = true; };

    isolateOutputs = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable PCI audio outputs (HDMI/motherboard) so only dedicated DAC/amp and Bluetooth outputs are available";
    };
  };

  config = lib.mkIf cfg.enable {
    # LV2 audio effect plugins (e.g. Stereo Tools, Gate, Equalizer)
    home.packages = with pkgs; [
      calf
      lsp-plugins
    ];

    # Seed mutable settings and presets on activation
    # Keeps files writable so EasyEffects can save tweaks and new presets from the UI
    home.activation.setupEasyeffects = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p "$HOME/.config/easyeffects/db"
      $DRY_RUN_CMD mkdir -p "$HOME/.local/share/easyeffects/input"

      for f in ${../../../dotfiles/easyeffects/input}/*; do
        filename=$(basename "$f")
        target="$HOME/.local/share/easyeffects/input/$filename"
        if [ ! -f "$target" ]; then
          $DRY_RUN_CMD cp "$f" "$target"
          $DRY_RUN_CMD chmod u+w "$target"
        fi
      done

      # Ensure fallback preset alias exists
      if [ ! -f "$HOME/.local/share/easyeffects/input/Normal.json" ] && [ -f "$HOME/.local/share/easyeffects/input/NORMAL-2.json" ]; then
        $DRY_RUN_CMD cp "$HOME/.local/share/easyeffects/input/NORMAL-2.json" "$HOME/.local/share/easyeffects/input/Normal.json"
      fi

      for f in ${../../../dotfiles/easyeffects/db}/*; do
        filename=$(basename "$f")
        target="$HOME/.config/easyeffects/db/$filename"
        if [ ! -f "$target" ]; then
          $DRY_RUN_CMD cp "$f" "$target"
          $DRY_RUN_CMD chmod u+w "$target"
        fi
      done
    '';

    # EasyEffects daemon service
    # On Arch, uses the native pacman binary with full host PipeWire/LV2/NVIDIA integration
    # On NixOS, seamlessly falls back to pkgs.easyeffects
    systemd.user.services.easyeffects = {
      Unit = {
        Description = "Easyeffects daemon";
        Requires = [ "pipewire.service" ];
        After = [ "pipewire.service" ];
        PartOf = [ "pipewire.service" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "easyeffects-launcher" ''
          if [ -x /usr/bin/easyeffects ]; then
            exec /usr/bin/easyeffects --hide-window --service-mode -l NORMAL-2
          else
            exec ${pkgs.easyeffects}/bin/easyeffects --hide-window --service-mode -l NORMAL-2
          fi
        ''}";
        Restart = "always";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # WirePlumber rule to filter outputs to only external DAC/amp & Bluetooth
    xdg.configFile."wireplumber/wireplumber.conf.d/51-disable-unwanted-outputs.conf" = lib.mkIf cfg.isolateOutputs {
      text = ''
        monitor.alsa.rules = [
          {
            matches = [
              {
                node.name = "~alsa_output.pci.*"
              }
            ]
            actions = {
              update-props = {
                node.disabled = true
              }
            }
          }
        ]
      '';
    };
  };
}
