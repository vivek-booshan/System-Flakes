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

		spicetify-nix = {
			url = "github:Gerg-L/spicetify-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

	  # Nix-homebrew
	  nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

	};

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
					inherit inputs outputs;
					userConfig = users.${username};
				};
				modules = [
					./home-manager/home.nix
					# NOTE: once multiple users : ./home-manager/${hostname}/${username}.nix 
				];

			};

	in {

		#usage : darwin-rebuild switch --flake /path/to/flakes/#m1mac --show-trace
		darwinConfigurations = {
			m1mac = mkDarwinConfiguration "m1mac";
		};

		#usage : home-manager switch --flake /path/to/flakes#vivek@m1mac --show-trace
		homeConfigurations = {
			"vivek@m1mac" = mkHomeConfiguration "aarch64-darwin" "m1mac" "vivek";
		};

	};
		
} #EOF closing bracket
