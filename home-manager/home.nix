{ config, pkgs, ... }: 

{
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "vivek";
    homeDirectory = "/Users/vivek";

    packages = with pkgs; [
      # useful cli tools
      ripgrep
      eza
      lazygit
      htop
      bat
      neofetch
      fzf
      fd
      zoxide
      
      # language servers
      python312Packages.python-lsp-server
      ols
      zls

      uv
      
      # terminal related
      kitty
      starship
      fish
      fishPlugins.fzf-fish
      fishPlugins.fifc
      tmux
      tmuxPlugins.gruvbox

      # fonts
      jetbrains-mono

      # spicetify
      spicetify-cli

      #languages
      odin
      zig

      # c tools
      gcc
      gperftools
    ]; 

    sessionVariables = {
      EDITOR = "helix";
      TERM = "fish";
    };
 
    file.".tmux.conf".text = builtins.readFile ./dotfiles/.tmux.conf;
  };  

  xdg = {
    enable = true;
    configFile = {  
      ".tmux.conf".source = ./dotfiles/.tmux.conf;
      "starship.toml".source = ./dotfiles/starship.toml;
      "fish/config.fish".source = ./dotfiles/fish/config.fish;
      "helix/config.toml".source = ./dotfiles/helix/config.toml;
      "helix/languages.toml".source = ./dotfiles/helix/languages.toml;
      # "helix/themes/everforest_transparent.toml".source = ./dotfiles/helix/themes/everforest_transparent.toml;
      "kitty/kitty.conf".source = ./dotfiles/kitty/kitty.conf;
      # kitty searches the config directory when using the `include <theme>.conf` command
      # "kitty/gruvbox_dark.conf".source = ./dotfiles/kitty/gruvbox_dark.conf;
      "kitty/everforest.conf".source = ./dotfiles/kitty/everforest.conf;
    };
  };

  # imports = [
  #   ./dotfiles/spicetify.nix
  # ];

  programs = {

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    tmux = {
      enable = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      # keybindings = true;
    };

    zoxide.enable = true;

  };
  
}
