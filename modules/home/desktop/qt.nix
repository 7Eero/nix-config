{ pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
    kvantum = {
      enable = true;
      settings = {
        General.theme = "KvLibadwaita";
      };
    };
  };

  # Link the KvLibadwaita theme assets for Kvantum
  xdg.configFile."Kvantum/KvLibadwaita".source = ../../../dotfiles/Kvantum/KvLibadwaita;
}
