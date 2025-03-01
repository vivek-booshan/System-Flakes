{
  description = "A Nix-flake-based Arduino development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs =
    { self
    , nixpkgs
    }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems (system:
          f {
            pkgs = import nixpkgs { inherit system; };
          });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            arduino-cli  # Arduino CLI for compiling/uploading sketches
            avr-gcc      # AVR GCC toolchain
            avr-libc     # Standard C library for AVR
            avrdude      # Flashing tool for AVR microcontrollers
            picocom      # Serial monitor (alternative: `minicom`, `screen`)
          ];

          shellHook = ''
            echo "Arduino development environment loaded!"
            echo "Run 'arduino-cli board list' to check connected devices."
          '';
        };
      });
    };
}
