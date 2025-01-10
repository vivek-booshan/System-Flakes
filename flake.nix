{
	description = "nix-darwin system flake"; # You can change this to whatever

	inputs = {
	  # Nixpkgs
	  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

	  # Home manager
		home-manager = {
		  url = "github:nix-community/home-manager";
		  inputs.nixpkgs.follows = "nixpkgs";
		};

	  # Nix-darwin
	  nix-darwin.url = "github:LnL7/nix-darwin";
	  nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

		# spicetify-nix = {
		# 	url = "github:Gerg-L/spicetify-nix";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# };

	  # Hardware (optional for nix-darwin)
	  # hardware.url = "github:nixos/nixos-hardware";

	  # Nix-homebrew
	  nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

	};

# 	outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, nix-homebrew, ... }: {
# 	 # nix-darwin configuration entrypoint
# 	 # Available through 'darwin-rebuild --flake .#your-hostname'

# 		darwinConfigurations = {
# 			  m1mac       = nix-darwin.lib.darwinSystem {
# 				system      = "aarch64-darwin"; # Adjust the system type if needed
# 				specialArgs = { inherit  inputs  self;  }; # Pass flake inputs to our config
# 				modules     = [ 
# 				  ./nix-darwin/configuration.nix
# 				];
# 			};
# 		};

# 		# home-manager configuration entrypoint
# 		# Available through 'home-manager --flake .#your-username@your-hostname'
# 		homeConfigurations = {
# 			"vivek@m1mac" = home-manager.lib.homeManagerConfiguration {
# 				# pkgs            = nixpkgs.legacyPackages.aarch64-darwin; # Adjust for Darwin
# 				pkgs              = import nixpkgs { system = "aarch64-darwin"; };
# 				extraSpecialArgs  = { inherit inputs; }; # Pass flake inputs to our config
# 				modules           = [ 
# 					./home-manager/home.nix 
# 				];
# 			};
# 		};
# 	};

# }

	outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, nix-homebrew, ... }: let
		inherit (self) outputs;

		users = {
			vivek = { name = "vivek"; };
		};
		
		# Make Darwin Configuration with arguments 
		# Usage : mkDarwinConfiguration "hostname" "username"

		mkDarwinConfiguration = hostname: #: username:
			nix-darwin.lib.darwinSystem {
				system =  "aarch64-darwin";
				specialArgs = {
					inherit self inputs outputs hostname;
					# userConfig = users.${username};
				};
				modules = [
					./nix-darwin/configuration.nix
					home-manager.darwinModules.home-manager
					nix-homebrew.darwinModules.nix-homebrew
				];

			};

		# Usage : mkHomeConfiguration "system" "hostname" "username"
		mkHomeConfiguration = system: hostname: username:
			home-manager.lib.homeManagerConfiguration {

				pkgs = import nixpkgs { system = system; };
				extraSpecialArgs = {
					inherit inputs;
					userConfig = users.${username};
				};
				modules = [
					./home-manager/home.nix
					# once multiple users : ./home-manager/${hostname}/${username}.nix 
				];

			};

	in {

		darwinConfigurations = {
			m1mac = mkDarwinConfiguration "m1mac";
		};

		homeConfigurations = {
			"m1mac@vivek" = mkHomeConfiguration "aarch64-darwin" "m1mac" "vivek";
		};

	};
		
} #EOF closing bracket
