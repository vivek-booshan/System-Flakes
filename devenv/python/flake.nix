{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, poetry2nix }:
    let
      supportedSystems = ["x64_64-linux" "aarch64-linux" "x64_64-darwin" "aarch64-darwin"];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {inherit system};
        inherit (poetry2nix.legacyPackages.${pkgs.system}) mkPoetryPackages;
        pyEnv = mkPoetryPackages {
            projectDir = ./.;
            preferWheels = true;
            groups = ["dev"];
        };
      });
    in
    {
      devShells = forEachSuppotedSystem({pkgs}: {
        default = pkgs.mkShell {
          name = "dev-shell";
          venvDir = ".venv";
          nativeBuildInputs = [
            poetry2nix.packages.${pkgs.system}.poetry
            pyEnv.poetryPackages
          ];
          packages = with pkgs; [ python312 ] ++
          (with pkgs.python312Packages; [
            venvShellHook
            numpy
            python-lsp-server
            matplotlib
            poetry
          ]);
        };
      });
    }
