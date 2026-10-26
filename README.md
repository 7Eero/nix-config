# nix-config

Modular Flake-based Home Manager and system configuration for Arch Linux and NixOS.

---

## Repository Structure

```text
~/.config/nix-config/
├── flake.nix                       # Flake inputs and host output definitions
├── flake.lock                      # Pinned dependency locks
├── dotfiles/                       # Raw dotfiles symlinked by Home Manager
│   ├── DankMaterialShell/
│   │   └── settings.json
│   └── niri/
│       └── config.kdl
├── modules/
│   └── home/
│       ├── core/                   # Base configuration shared across all hosts
│       │   ├── default.nix         # User identity, state version, unfree config
│       │   ├── packages.nix        # Core CLI utilities (ripgrep, eza, btop, fzf, etc.)
│       │   ├── session.nix         # Environment variables & systemd login service
│       │   └── git.nix             # Git credentials and configuration
│       ├── shell/                  # Shell configurations
│       │   ├── default.nix         # Shell aggregator
│       │   ├── zsh.nix             # Zsh + Aphrodite prompt, aliases, plugins, fzf
│       │   └── bash.nix            # Bash interactive fallback to Zsh
│       ├── terminal/               # Terminal emulators
│       │   └── alacritty.nix       # Alacritty fonts, padding, and theme settings
│       ├── gaming/                 # Gaming setup, compatibility, & emulation
│       │   ├── default.nix         # Gaming aggregator
│       │   ├── mangohud.nix        # MangoHud overlay configuration
│       │   ├── steam.nix           # Steam, Gamescope, Gamemode, & Protontricks
│       │   ├── launchers.nix       # Lutris, Prism Launcher, RuneLite, Wine, Piper
│       │   └── emulators.nix       # RetroArch & RPCS3
│       └── desktop/                # Graphical environment & Wayland components
│           ├── default.nix         # Desktop aggregator
│           ├── niri.nix            # Niri compositor config & DankMaterialShell setup
│           ├── theme.nix           # Cursor (Bibata), GTK theme, and dconf settings
│           ├── audio.nix           # EasyEffects presets and daemon service
│           ├── media.nix           # MPV configuration
│           ├── qt.nix              # Kvantum and Qt styling
│           └── apps/               # Modular desktop applications
│               ├── default.nix     # Apps aggregator
│               ├── browsers.nix    # Firefox, Brave Origin, Tor Browser
│               ├── communication.nix # Vesktop, Signal, Element, Cinny, Thunderbird, Zoom
│               ├── multimedia.nix  # OBS Studio (PipeWire), Spotify, Kdenlive, Audacity, Komikku
│               ├── productivity.nix # Obsidian, Zotero, OnlyOffice, KeePassXC, Nextcloud, Thunar
│               └── development.nix # VS Code, Antigravity IDE, AppImage runner, nixd
└── hosts/
    ├── arch/
    │   └── default.nix             # Arch profile (genericLinux, native Alacritty)
    └── nixos/
        ├── default.nix             # NixOS Home Manager profile (Core + Desktop + Gaming)
        └── system/
            ├── configuration.nix   # NixOS system-level configuration (Steam, GameMode, GNOME, PipeWire)
            └── hardware-configuration.nix
```

---

## Usage

### 1. Apply Configuration Changes

* **On Arch Linux (Standalone Home Manager):**
  ```bash
  home-manager switch --flake ~/.config/nix-config
  # or explicitly:
  home-manager switch --flake ~/.config/nix-config#eero@archlinux
  ```

* **On NixOS (System Rebuild):**
  ```bash
  sudo nixos-rebuild switch --flake ~/.config/nix-config#nixos
  ```

* **On NixOS (Standalone Home Manager):**
  ```bash
  home-manager switch --flake ~/.config/nix-config#eero@nixos
  ```

### 2. Check / Evaluate Flake

To verify configuration syntax and module evaluation without applying:

```bash
nix flake check --no-build
```

### 3. Update Flake Inputs

To update all inputs (`nixpkgs`, `home-manager`, `niri`, etc.) to their latest revisions:

```bash
nix flake update
```

### 4. Background Services

To inspect the status of the user environment auto-activation service on standalone systems:

```bash
systemctl --user status home-manager-ensure.service
```