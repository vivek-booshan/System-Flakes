{
  description = "Vivek's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";    

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, ... }:
  let
    configuration = { config, pkgs, lib, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget

      # Allow unfree apps : nixpkgs.config.allowUnfree = true;
      # Configure predicate to declare specific free apps 

      nixpkgs.config.allowUnfreePredicate = pkg : builtins.elem (lib.getName pkg) [
        "spotify"
        "discord"
      ];

      environment.systemPackages =
        [ 
          pkgs.helix
          pkgs.mkalias # for making aliases for spotlight
          pkgs.python312Packages.python-lsp-server
          pkgs.eza # better ls
          pkgs.kitty 
          pkgs.git
          pkgs.lazygit
          pkgs.starship
          pkgs.fish
          #pkgs.wiringpi
          # pkgs.spotify #can't get spotlight detection to work or aerospace launcher
          # pkgs.discord
        ];

      fonts.packages = [
        # (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        pkgs.nerd-fonts.jetbrains-mono
      ];

      homebrew = {

        enable = true;
        global.autoUpdate = false;

        casks = [
          "aerospace"
          "spotify"
          "discord"
          "zen-browser"
          "raspberry-pi-imager"
        ];

        taps = [
          "nikitabobko/tap"
        ];

        # brews = [
        #   "fish"
        # ];

        onActivation.cleanup = "zap";
        onActivation.autoUpdate = false;
        onActivation.upgrade = false;
      };

      # in conjunction with mkalias to display on spotlight
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
      };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
            '';

      # system.activationScripts.linkHomebrewCasks = {
      #   enable=true;
      #   text = ''
      #   echo "Linking Homebrew cask binaries to /run/current-system/sw/bin..." >&2

      #   caskroom="/opt/homebrew/Caskroom"
      #   bin_dir="/run/current-system/sw/bin"

      #   if [ ! -d "$bin_dir" ]; then
      #     echo "Error: Directory $bin_dir does not exist!" >&2
      #     exit 1
      #   fi

      #   # Iterate over each application directory in Caskroom
      #   for app in "$caskroom"/*; do
      #     # Get the latest version of the app
      #     version=$(ls -t "$app" | head -n 1)  
      #     app_dir="$app/$version"  # Full path to the latest version directory

      #     # Iterate over all .app directories (this should match the .app directory)
      #     for app_bundle in "$app_dir"/*.app; do
      #       if [ -d "$app_bundle" ]; then
      #         # Now that we have a valid .app directory, look for binaries inside Contents/MacOS
      #         binary_dir="$app_bundle/Contents/MacOS"
      
      #         if [ -d "$binary_dir" ]; then
      #           # Iterate over the binaries inside the Contents/MacOS folder
      #           for binary in "$binary_dir"/*; do
      #             if [ -f "$binary" ]; then
      #               # Extract the binary name
      #               if [[ "$binary" =~ /Contents/MacOS/([^/]+) ]]; then
      #                 app_name="${BASH_REMATCH[1]}"  # Extract binary name
      #                 echo "Linking $app_name to $bin_dir/$app_name" >&2
      #                 ln -sf "$binary" "$bin_dir/$app_name"
      #               else
      #                 echo "No valid binary found in $binary" >&2
      #               fi
      #             else
      #               echo "No binary found in $binary_dir" >&2
      #             fi
      #           done
      #         else
      #           echo "No binary directory found in $app_bundle/Contents/MacOS" >&2
      #         fi
      #       else
      #         echo "No .app directory found for $app_bundle" >&2
      #       fi
      #     done
      #   done
      #   '';
      #   target="switch";
      # };
      security.pam.enableSudoTouchIdAuth = true;

      # Auto upgrade nix package and daemon service
      services.nix-daemon.enable = true;
      
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
  
      # time zone used when displaying times and dates
      time.timeZone = "America/New_York";
      
      system = {

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        stateVersion = 5;

        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;
        
        defaults.dock = {
          # Whether to automatically hide and show the dock. Default is false.
          autohide = true;
          # Sets the speed of autohide delay. Default is 0.24
          autohide-delay = 0.0;
          # Sets the speed of the animation when hid/showing the dock. Default is 1.0
          autohide-time-modifier = 0.0;
          # Animate opening applications from the dock. Default is true
          launchanim = false;
          # Show recent applications in the dock. Default is true
          show-recents = false;
          # Position of the dock on screen. Default is "bottom"
          orientation = "bottom";
          # Show indicator lights for open applications in the Dock. Default is true
          show-process-indicators = true;
          # Whether to make icons of hidden applications translucent. Default is false
          showhidden = true;
          # Show only open applications in the Dock
          static-only = true;
        };

        defaults.finder = {
          # Whether to always show file extensions. Default is false
          AppleShowAllExtensions = true;
          # Whether to always show hidden files. Default is false
          AppleShowAllFiles = true;
          # Whether to allow quitting of Finder. Default is false
          QuitMenuItem = true;
          # Whether to show hard disks on desktop. Default is false
          ShowHardDrivesOnDesktop = true;
          # Whether to show connected servers on desktop. Default is false
          ShowMountedServersOnDesktop = true;
          # Show path breadcrumbs in finder windows. Default is false
          ShowPathbar = true;
          # Show status bar at bottom of finder windows with item/disk space stats. The default is false.
          ShowStatusBar = true;
          # Whether to show the full POSIX filepath in the window title. Default is false
          _FXShowPosixPathInTitle = true;
          # Keep folders on top when sorting by name. Default is false 
          _FXSortFoldersFirst = true;
          # Keep folders on top when sorting by name on desktop. Default is false
          _FXSortFoldersFirstOnDesktop = true;
          # Change the default finder view. “icnv” = Icon view, “Nlsv” = List view, “clmv” = Column View, “Flwv” = Gallery View The default is icnv.
          FXPreferredViewStyle = "Nlsv";
        };

        defaults.NSGlobalDomain = {
          # Whether to use 24-hour or 12-hour time. Default based on region settings
          AppleICUForce24HourTime = true;
          # Configures keyboard control behavior. Mode 3 enables full keyboard control
          AppleKeyboardUIMode = 3;
          # Whether to use the metric system. Default is based on region settings
          AppleMetricUnits = 1;
          # Whether to autohide the menu bar. Default is false
          # _HIHideMenuBar = false;
          # Whether to show all file extensions in Finder. The default is false.
          AppleShowAllExtensions = true;
          # Whether to always show hidden files. The default is false
          AppleShowAllFiles = true;
          # Whether to animate opening and closing of windows and popovers. The default is true.
          NSAutomaticWindowAnimationsEnabled = false;
          
        };

        defaults.menuExtraClock = {
          # Show a 24-hour clock
          Show24Hour = true;
          # Show the full date. 0 = When Space allows; 1 = Always; 2 = Never
          ShowDate = 0;
          # Show seconds
          ShowSeconds = true;
        };

        # Show Battery Percentage 
        defaults.controlcenter.BatteryShowPercentage = true;
        
        # Target to which screencapture should save screenshot to.
        # apprently this option does not exist
        # defaults.screencapture.target = "clipboard";

        # Disable animation when switching screens or opening apps
        # defaults.universalaccess.reduceMotion = true;
      };

      # services.aerospace.enable = true;
      
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Viveks-MacBook-Pro
    darwinConfigurations."Viveks-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration 
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under default prefix
            enable = true;
            # If Apple Silicon
            enableRosetta = true;
            # User owning the Homebrew prefix 
            user = "vivek";
            autoMigrate = true;
          };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."Viveks-MacBook-Pro".pkgs;
  };
}
