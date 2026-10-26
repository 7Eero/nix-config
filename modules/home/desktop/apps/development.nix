{ pkgs, inputs, ... }:

{
  # Visual Studio Code with Nix Language Support
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
  };

  # Development tools, editors, and formatters
  home.packages = with pkgs; [
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-ide

    # appimage-run with webkit2gtk bundled for Electron/WebKitGTK AppImages
    (appimage-run.override {
      extraPkgs = p: with p; [ webkitgtk_4_1 libsoup_3 gdk-pixbuf openssl libayatana-appindicator ];
    })

    # Language Tooling & Formatters
    nixd
    nixfmt
  ];
}
