{ config, pkgs, ... }:

{
  # Session environment variables (propagated to shells, systemd --user, and Wayland sessions)
  home.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
    ADW_DEBUG_COLOR_SCHEME = "prefer-dark";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_QPA_PLATFORM = "wayland";
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    MANPAGER = "nvim +Man!";

    # Keep $HOME clean from stray app files, caches, and dumps (XDG compliance)
    XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
    CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
    __GL_SHADER_DISK_CACHE_PATH = "${config.xdg.cacheHome}/nv";
    DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    WGETRC = "${config.xdg.configHome}/wget/wgetrc";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    NPM_CONFIG_DEVDIR = "${config.xdg.cacheHome}/node-gyp";
    GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
    ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
    PULSE_COOKIE = "${config.xdg.configHome}/pulse/cookie";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
  };

  # User service to ensure Home Manager session and environment are loaded on login (for Arch & standalone)
  systemd.user.services.home-manager-ensure = {
    Unit = {
      Description = "Ensure Home Manager environment is active on login";
      Documentation = [ "https://github.com/nix-community/home-manager" ];
      After = [ "basic.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.writeShellScript "hm-ensure-env" ''
        for p in "$HOME/.nix-profile" "/etc/profiles/per-user/$USER"; do
          if [ -f "$p/etc/profile.d/hm-session-vars.sh" ]; then
            . "$p/etc/profile.d/hm-session-vars.sh"
            break
          fi
        done
        ${pkgs.systemd}/bin/systemctl --user import-environment PATH XDG_DATA_DIRS GTK_THEME QT_QPA_PLATFORM EDITOR TERMINAL CUDA_CACHE_PATH __GL_SHADER_DISK_CACHE_PATH GRADLE_USER_HOME ANDROID_USER_HOME NPM_CONFIG_CACHE NPM_CONFIG_USERCONFIG PULSE_COOKIE
        if command -v dbus-update-activation-environment >/dev/null 2>&1; then
          dbus-update-activation-environment --systemd PATH XDG_DATA_DIRS GTK_THEME QT_QPA_PLATFORM EDITOR TERMINAL CUDA_CACHE_PATH __GL_SHADER_DISK_CACHE_PATH GRADLE_USER_HOME ANDROID_USER_HOME NPM_CONFIG_CACHE NPM_CONFIG_USERCONFIG PULSE_COOKIE
        fi
      ''}";
    };
  };

  # Automatically start / restart systemd user units on activation
  systemd.user.startServices = "sd-switch";
}
