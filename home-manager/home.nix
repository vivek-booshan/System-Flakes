{ config, pkgs, ... }: 

{
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  home = {
    username = "vivek";
    homeDirectory = "/Users/vivek";

    packages = with pkgs; [
      # useful commands
      ripgrep
      eza
      lazygit
      htop
      bat
      neofetch

      # language servers
      python312Packages.python-lsp-server

      # terminal related
      kitty
      starship
      fish

      # fonts
      jetbrains-mono

      spicetify-cli
  
    ]; 

    sessionVariables = {
      EDITOR = "helix";
      TERM = "fish";
    };
  };  

  xdg = {
    configFile = {  
      "starship.toml".source = ./dotfiles/starship.toml;
      "fish/config.fish".source = ./dotfiles/fish/config.fish;
      "helix/config.toml".source = ./dotfiles/helix/config.toml;
      "kitty/kitty.conf".source = ./dotfiles/kitty/kitty.conf;
      # kitty searches the config directory when using the `include <theme>.conf` command
      "kitty/gruvbox_dark.conf".source = ./dotfiles/kitty/gruvbox_dark.conf;
    };
  };

  programs = {
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };
  
}
