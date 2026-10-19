# nix-config

## Repository Structure

```text
~/.config/nix-config/
├── flake.nix        # Flake inputs and host output definitions
├── home.nix         # Common configuration (packages, Zsh, Git, Alacritty styling)
└── hosts/
    ├── arch.nix     # Arch Linux profile (enables genericLinux, uses native Alacritty binary)
    └── nixos.nix    # NixOS profile (native GPU acceleration, Nix-managed packages)
```

---

## Usage

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