{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" "toml" "kdl" ];
    userSettings = {
      hour_format = "hour24";
      languages = {
        "Nix" = {
          language_servers = [ "nixd" "!nil" ];
        };
        lsp = {
              nix = {
                binary = {
                  path_lookup = true;
                };
              };
            };
      };
    };
  };
}
