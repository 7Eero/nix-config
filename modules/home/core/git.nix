{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "7Eero";
      user.email = "126098783+7Eero@users.noreply.github.com";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };
}
