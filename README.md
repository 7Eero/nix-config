# nix-config

Flake-based Home Manager and system configuration for Arch Linux and NixOS.

---

## Repository Structure

```text
~/.config/nix-config/
├── flake.nix        # Flake inputs and host output definitions
├── flake.lock       # Pinned dependency locks
├── home.nix         # Shared user configuration (packages, Zsh, Git, environment, systemd)
├── dotfiles/        # Standalone config files symlinked into place
│   ├── DankMaterialShell/settings.json
│   └── niri/config.kdl
└── hosts/
    ├── arch.nix     # Arch Linux profile (genericLinux enabled, native Alacritty)
    └── nixos.nix    # NixOS profile (Niri compositor, GPU acceleration, DankMaterialShell)
```

## Usage

### 1. Apply Configuration Changes

* **On Arch Linux:**
  ```bash
  home-manager switch --flake ~/.config/nix-config
  ```
  *(Or use the shell alias `hm-switch`)*

* **On NixOS (Standalone Home Manager):**
  ```bash
  home-manager switch --flake ~/.config/nix-config#eero@nixos
  ```

* **On NixOS (System-level Rebuild, if using NixOS flake module):**
  ```bash
  sudo nixos-rebuild switch --flake ~/.config/nix-config#nixos
  ```

### 2. Update Flake Inputs

To update all inputs (nixpkgs, home-manager, niri, etc.) to their latest revisions:

```bash
nix flake update --flake ~/.config/nix-config
home-manager switch --flake ~/.config/nix-config
```

### 3. Verify Background Services

To check the status of the user environment auto-activation service:

```bash
systemctl --user status home-manager-ensure.service
```