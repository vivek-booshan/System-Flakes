{ self, config, pkgs, inputs, lib, ... }: 

{
  nixpkgs.config.allowUnfree = true;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';


  environment.systemPackages = with pkgs; 
    [
      helix
      mkalias
      git
      fish
    ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  imports = [
    ./system.nix
    ./homebrew.nix
  ];

  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and daemon service
  services.nix-daemon.enable = true;
  
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # time zone used when displaying times and dates
  time.timeZone = "America/New_York";

  # Enable alternative shell support in nix-darwin.
  programs.fish.enable = true;
  # services.aerospace.enable = true;
 
  users.users.vivek = {
    shell = pkgs.fish;
  };

}
