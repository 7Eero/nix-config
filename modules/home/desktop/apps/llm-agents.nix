{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.dsh
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2-desktop
  ];
}
