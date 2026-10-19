# nix-config

Declarative user environment managed with **Nix Flakes** and **Home Manager**, configured to support both **Arch Linux** and **NixOS**.

---

## 📁 Repository Structure

```text
~/.config/nix-config/
├── flake.nix        # Flake inputs and host output definitions
├── home.nix         # Common configuration (packages, Zsh, Git, Alacritty styling)
└── hosts/
    ├── arch.nix     # Arch Linux profile (enables genericLinux, uses native Alacritty binary)
    └── nixos.nix    # NixOS profile (native GPU acceleration, Nix-managed packages)
```

---

## 🚀 Usage

### Apply Configuration Changes

* **On Arch Linux:**
  ```bash
  home-manager switch --flake ~/.config/nix-config
  ```

* **On NixOS:**
  ```bash
  home-manager switch --flake ~/.config/nix-config#eero@nixos
  ```

### Update Flake Inputs (nixpkgs, etc.)

```bash
nix flake update --flake ~/.config/nix-config
home-manager switch --flake ~/.config/nix-config
```

---


## 💻 First-Time Setup on a New Machine

1. Ensure Nix and Flakes are installed and enabled.
2. Clone this repository:
   ```bash
   git clone https://github.com/7Eero/nix-config.git ~/.config/nix-config
   ```
3. Apply the appropriate host profile:
   * **Arch:** `nix run github:nix-community/home-manager -- switch --flake ~/.config/nix-config#eero@archlinux`
   * **NixOS:** `nix run github:nix-community/home-manager -- switch --flake ~/.config/nix-config#eero@nixos`
