{ self, config, pkgs, ... }:

{

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

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

  system = {

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

      # Whether to show icons on the desktop or not. The default is true.
      CreateDesktop = false;

      # Change the default search scope. Use "SCcf" to default to current folder. The default is unset ("This Mac")
      FXDefaultSearchScope = "SCcf";

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
}
