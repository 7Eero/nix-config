{ pkgs, ... }:

{
  # Session environment variables (propagated to shells, systemd --user, and Wayland sessions)
  home.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
    ADW_DEBUG_COLOR_SCHEME = "prefer-dark";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_QPA_PLATFORM = "wayland";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
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
        if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
          . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
          ${pkgs.systemd}/bin/systemctl --user import-environment PATH XDG_DATA_DIRS GTK_THEME QT_QPA_PLATFORM EDITOR
          if command -v dbus-update-activation-environment >/dev/null 2>&1; then
            dbus-update-activation-environment --systemd PATH XDG_DATA_DIRS GTK_THEME QT_QPA_PLATFORM EDITOR
          fi
        fi
      ''}";
    };
  };

  # Automatically start / restart systemd user units on activation
  systemd.user.startServices = "sd-switch";
}
