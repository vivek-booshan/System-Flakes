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

  # Enable alternative shell support in nix-darwin.
  programs.fish.enable = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # time zone used when displaying times and dates
  time.timeZone = "America/New_York";
  
  

  # services.aerospace.enable = true;
 
  users.users.vivek = {
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

}
