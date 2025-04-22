{
  description = "Zig Dev Env"

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = ["x64_64-linux", "aarch64-linux" "x64_64-darwin" "aarch64-darwin"];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {inherit system};
      });
    in
    {
      devShells = forEachSupportedSystem ({pkgs}: {
        default = pkgs.mkShell {
          packages = with pkgs; [zig zls lldb];
        };
      });
    };
}
