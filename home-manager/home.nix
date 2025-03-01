{ config, pkgs, homeDirectory, ... }: 

{
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "vivek";
    homeDirectory = homeDirectory;

    packages = with pkgs; [
      # useful cli tools
      ripgrep
      eza
      lazygit
      bat
      fzf
      fd
      zoxide
      
      # language servers
      python312Packages.python-lsp-server

      # terminal related
      kitty # to get the nix kitty to work, set up nixGL, otherwise use the local version
      helix
      starship
      fish
      fishPlugins.fzf-fish
      fishPlugins.fifc
      tmux
      st
      #### better to just manually work with that instead of using nix for now
      # (st.overrideAttrs (oldAttrs: rec {
      #   buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
      #   patches = [
      #     # gruvbox
      #     (fetchpatch {
      #       url =  "https://st.suckless.org/patches/gruvbox-material/st-gruvbox-material-0.8.2.diff";
      #       sha256 = "13wjrjkzzsmxw2lfb1cirkrk2dyg6zawflvwb11l62zlsg05x3r9";
      #     })
      #   ];

      #   configFile = writeText "config.def.h" (builtins.readFile /home/vivek/.config/flakes/dotfiles/st/config.h);
      #   postPatch = "{oldAttrs.postPatch}\n cp ${configFile} config.def.h";
      # }))

      # c-lang
      valgrind
      gdb
     ]; 

    sessionVariables = {
      EDITOR = "helix";
      TERM = "fish";
    };
 
    # file.".tmux.conf".text = builtins.readFile ./dotfiles/.tmux.conf;
  };  

  xdg = {
    enable = true;
    configFile = {  
      "starship.toml".source = ./dotfiles/starship.toml;
      "fish/config.fish".source = ./dotfiles/fish/config.fish;
      "helix/config.toml".source = ./dotfiles/helix/config.toml;
      "kitty/kitty.conf".source = ./dotfiles/kitty/kitty.conf;
      "tmux/tmux.conf".source = ./dotfiles/tmux/tmux.conf;
      # kitty searches the config directory when using the `include <theme>.conf` command
      "kitty/everforest.conf".source = ./dotfiles/kitty/everforest.conf;
    };
  };

  # imports = [
  #   ./dotfiles/spicetify.nix
  # ];

  programs = {

    # fish.enable = true;

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

    direnv = {
      enable = true;
      # enableFishIntegration = true;
      nix-direnv.enable = true;
    };

  };
  
}
