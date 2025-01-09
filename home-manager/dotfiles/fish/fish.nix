{ config, pkgs, ... } :

{
  programs.fish.enable = true;
  xdg.configFile."fish/config.fish".source = "./config.fish"

}
