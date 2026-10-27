{ pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
    kvantum = {
      enable = true;
      settings = {
        General.theme = "KvLibadwaitaDark";
      };
    };
  };

  # Link the KvLibadwaita theme assets for Kvantum
  xdg.configFile."Kvantum/KvLibadwaita".source = ../../../dotfiles/Kvantum/KvLibadwaita;
  xdg.configFile."Kvantum/KvLibadwaitaDark".source = ../../../dotfiles/Kvantum/KvLibadwaitaDark;
}
