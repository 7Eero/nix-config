{ pkgs, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "7Eero";
        email = "126098783+7Eero@users.noreply.github.com";
      };
      ui = {
        default-command = "log";
      };
    };
  };
}