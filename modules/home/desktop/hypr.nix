{ pkgs, lib, ... }:

let
  dmsIncludes = [
    "outputs"
    "layout"
    "input"
    "windowrules"
    "cursor"
    "binds"
    "binds-user"
  ];
in
{
  wayland.windowManager.hyprland = {
    enable = false;
    package = null;
    portalPackage = null;

    configType = "lua";

    # UWSM owns graphical-session.target and friends; Hyprland's own systemd
    # integration would fight it.
    systemd.enable = false;

    settings = {
      config = {
        general = {
          layout = "scrolling";
          gaps_in = 2;
          gaps_out = 4;
          border_size = 2;
          resize_on_border = true;
        };

        scrolling = {
          column_width = 0.5;
          direction = "right";
          follow_focus = 1;
          focus_fit_method = 1;
          follow_min_visible = 0.4;
        };

        decoration = {
          rounding = 1;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          shadow.enabled = true;
          blur.enabled = false;
        };

        animations.enabled = false;

        input = {
          kb_layout = "fi";
          kb_variant = "nodeadkeys";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad.natural_scroll = false;
          force_no_accel = false;
        };

        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = true;
        };

        workspace = [
          "1, monitor:DP-1"
          "4, monitor:DP-3"
          "5, monitor:DP-2"
        ];
      };
    };

    extraConfig = ''
      -- Make the Hyprland config directory require-able even without using
      -- extraLuaFiles (DMS writes its fragments there).
      package.path = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/hypr/?.lua;" .. package.path

      -- DMS-managed fragments (created empty on activation, filled in by DMS)
      ${lib.concatMapStrings (name: "require(\"dms.${name}\")\n") dmsIncludes}

      hl.env("XCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_SIZE", "24")
      hl.env("LIBVA_DRIVER_NAME", "nvidia")
      hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
      hl.env("NVD_BACKEND", "direct")

      -- Start the shell once the compositor is up
      hl.on("hyprland.start", function()
        hl.exec_cmd("dms run")
      end)

      local mod = "SUPER"

      -- Launchers / window management
      hl.bind(mod .. " + Return", hl.dsp.exec_cmd("alacritty"))
      hl.bind(mod .. " + Q", hl.dsp.window.close())
      hl.bind(mod .. " + T", hl.dsp.exec_cmd("thunar"))
      hl.bind(mod .. " + D", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
      hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
      hl.bind(mod .. " + P", hl.dsp.window.pseudo())
      hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())

      -- Toggle between the scrolling tape and normal tiling (dwindle)
      hl.bind(mod .. " + M", function()
        local current = hl.get_config("general.layout")
        local target = (current == "scrolling") and "dwindle" or "scrolling"
        hl.exec_cmd("hyprctl keyword general:layout " .. target)
      end)

      -- Scrolling tape navigation (no-ops while dwindle is active)
      hl.bind(mod .. " + left", hl.dsp.layout("focus l"))
      hl.bind(mod .. " + right", hl.dsp.layout("focus r"))
      hl.bind(mod .. " + H", hl.dsp.layout("focus l"))
      hl.bind(mod .. " + L", hl.dsp.layout("focus r"))
      hl.bind(mod .. " + SHIFT + left", hl.dsp.layout("swapcol l"))
      hl.bind(mod .. " + SHIFT + right", hl.dsp.layout("swapcol r"))
      hl.bind(mod .. " + SHIFT + H", hl.dsp.layout("swapcol l"))
      hl.bind(mod .. " + SHIFT + L", hl.dsp.layout("swapcol r"))
      hl.bind(mod .. " + comma", hl.dsp.layout("move -col"))
      hl.bind(mod .. " + period", hl.dsp.layout("move +col"))
      hl.bind(mod .. " + equal", hl.dsp.layout("colresize +conf"))
      hl.bind(mod .. " + minus", hl.dsp.layout("colresize -conf"))

      -- Column / window focus in the other axis
      hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

      -- Workspaces
      for i = 1, 9 do
        local key = tostring(i % 10)
        hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end
      hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

      -- Drag/resize with the mouse
      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Media keys
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
    '';
  };

  # Empty fragments so `require("dms.*")` cannot fail before DMS has written
  # anything. Files stay writable so DMS can manage them.
  home.activation.setupHyprDms = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.config/hypr/dms"
    ${lib.concatMapStrings (name: ''
      if [ ! -f "$HOME/.config/hypr/dms/${name}.lua" ]; then
        $DRY_RUN_CMD touch "$HOME/.config/hypr/dms/${name}.lua"
      fi
    '') dmsIncludes}
  '';

  home.packages = [ pkgs.uwsm ];
}
