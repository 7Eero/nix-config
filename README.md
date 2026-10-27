# nix-config

Modular Flake-based Home Manager and system configuration for Arch Linux and NixOS.

---

## Repository Structure

```text
~/.config/nix-config/
├── flake.nix
├── flake.lock
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
│       │   └── git.nix
│       ├── shell/
│       │   ├── default.nix
│       │   ├── zsh.nix             # Zsh + Aphrodite prompt, aliases, plugins, fzf
│       │   └── bash.nix            # Bash interactive fallback to Zsh
│       ├── terminal/
│       │   └── alacritty.nix
│       ├── gaming/
│       │   ├── default.nix
│       │   ├── mangohud.nix
│       │   ├── steam.nix           # Steam, Gamescope, Gamemode, & Protontricks
│       │   ├── launchers.nix       # Lutris, Prism Launcher, RuneLite, Wine, Piper
│       │   └── emulators.nix       # RetroArch & RPCS3
│       └── desktop/
│           ├── default.nix
│           ├── niri.nix            # Niri compositor config & DankMaterialShell setup
│           ├── theme.nix           # Cursor (Bibata), GTK theme, and dconf settings
│           ├── audio.nix           # EasyEffects presets and daemon service
│           ├── media.nix           # MPV configuration
│           ├── qt.nix              # Kvantum and Qt styling
│           └── apps/
│               ├── default.nix
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
    │       ├── configuration.nix   # NixOS Laptop system configuration
    │       └── hardware-configuration.nix
    └── nixos/
        ├── default.nix             # NixOS Desktop Home Manager profile
        └── system/
            ├── configuration.nix   # NixOS Desktop system configuration
            └── hardware-configuration.nix
```

---

## Setup

### 1. Enable Flakes
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### 2. Fresh NixOS Install
```bash
nix-shell -p git
git clone <repo-url> ~/.config/nix-config && cd ~/.config/nix-config
cp /etc/nixos/hardware-configuration.nix hosts/nixos/system/
git add hosts/nixos/system/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#nixos
```

---

## Usage

### Apply Configurations

```bash
# NixOS System Rebuild
sudo nixos-rebuild switch --flake ~/.config/nix-config

# Home Manager (Standalone)
home-manager switch --flake ~/.config/nix-config#eero@nixos
```

### Maintenance

```bash
nix flake check --no-build       
nix flake update
systemctl --user status home-manager-ensure.service
```