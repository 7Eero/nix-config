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
    ├── nixos-btw/
    │   ├── default.nix             # NixOS Laptop Home Manager profile (Core + Desktop + Gaming)
    │   └── system/
    │       ├── configuration.nix   # NixOS Laptop system configuration (hostname = "nixos-btw")
    │       └── hardware-configuration.nix
    └── nixos/
        ├── default.nix             # NixOS Desktop Home Manager profile
        └── system/
            ├── configuration.nix   # NixOS Desktop system configuration (hostname = "nixos")
            └── hardware-configuration.nix
```

---

## Initial Setup & Prerequisites

### 1. Enable Flakes Globally

On a fresh NixOS or generic Linux system, enable `nix-command` and `flakes` globally so you can run flake commands without extra flags:

* **System-wide (`/etc/nix/nix.conf`):**
  ```bash
  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
  ```

* **Or User-level (`~/.config/nix/nix.conf`):**
  ```bash
  mkdir -p ~/.config/nix
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
  ```

*(Once your configuration is applied, this is managed declaratively by `nix.settings.experimental-features = [ "nix-command" "flakes" ];` in [configuration.nix](hosts/nixos/system/configuration.nix)).*

### 2. Fresh NixOS Installation Quickstart

1. Install NixOS using the installer (ensure your user account is set to `eero`).
2. Boot into the system and start a shell with Git:
   ```bash
   nix-shell -p git
   ```
3. Enable flakes globally:
   ```bash
   echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
   ```
4. Clone your repository:
   ```bash
   git clone <repo-url> ~/.config/nix-config
   cd ~/.config/nix-config
   ```
5. Copy the installer's generated hardware configuration into the repo:
   ```bash
   cp /etc/nixos/hardware-configuration.nix hosts/nixos/system/hardware-configuration.nix
   git add hosts/nixos/system/hardware-configuration.nix
   ```
   > [!IMPORTANT]
   > You **must** run `git add` on `hardware-configuration.nix`—Nix flakes will ignore untracked files!
6. Run the initial rebuild:
   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```
7. Reboot.

---

## Usage

### 1. Apply Configuration Changes

* **On Arch Linux Desktop (Standalone Home Manager):**
  ```bash
  home-manager switch --flake ~/.config/nix-config
  # or explicitly:
  home-manager switch --flake ~/.config/nix-config#eero@archlinux
  ```

* **On NixOS Laptop (System Rebuild):**
  ```bash
  sudo nixos-rebuild switch --flake ~/.config/nix-config#nixos-btw
  ```

* **On NixOS Laptop (Standalone Home Manager):**
  ```bash
  home-manager switch --flake ~/.config/nix-config#eero@nixos-btw
  ```

* **On NixOS Desktop (System Rebuild):**
  ```bash
  sudo nixos-rebuild switch --flake ~/.config/nix-config#nixos
  ```

* **On NixOS Desktop (Standalone Home Manager):**
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