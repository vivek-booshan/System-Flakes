{
	description = "nix-darwin system flake"; # You can change this to whatever

	inputs = {
	  # Nixpkgs
	  nixpkgs.url                         = "github:NixOS/nixpkgs/nixos-unstable";

	  # Home manager
	  home-manager.url                    = "github:nix-community/home-manager";
	  home-manager.inputs.nixpkgs.follows = "nixpkgs";

	  # Nix-darwin
	  nix-darwin.url                      = "github:LnL7/nix-darwin";
	  nix-darwin.inputs.nixpkgs.follows   = "nixpkgs";

	  # Hardware (optional for nix-darwin)
	  # hardware.url                      = "github:nixos/nixos-hardware";

	  # Nix-homebrew
	  nix-homebrew.url                    = "github:zhaofengli-wip/nix-homebrew";

	};

	outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, nix-homebrew, ... }: {
	 # nix-darwin configuration entrypoint
	 # Available through 'darwin-rebuild --flake .#your-hostname'

		darwinConfigurations = {
			m1mac         = nix-darwin.lib.darwinSystem {
				system      = "aarch64-darwin"; # Adjust the system type if needed
				specialArgs = { inherit  inputs  self;  }; # Pass flake inputs to our config
				modules     = [ 
				  ./nix-darwin/configuration.nix
				];
			};
		};

		# home-manager configuration entrypoint
		# Available through 'home-manager --flake .#your-username@your-hostname'
		homeConfigurations = {
			"vivek@m1mac" = home-manager.lib.homeManagerConfiguration {
				# pkgs            = nixpkgs.legacyPackages.aarch64-darwin; # Adjust for Darwin
				pkgs              = import nixpkgs { system = "aarch64-darwin"; };
				extraSpecialArgs  = { inherit inputs; }; # Pass flake inputs to our config
				modules           = [ 
					./home-manager/home.nix 
				];
			};
		};
	};

}
