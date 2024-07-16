{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.hercules-ci-effects.flakeModule
      ];

      systems = [ "x86_64-linux" ];
      herculesCI.ciSystems = [ "x86_64-linux" ];

      perSystem = { config, system, lib, self', ... }:
        let
          pkgs = import nixpkgs {inherit system;};
        in {
          packages.default = pkgs.hello;
          checks.default = pkgs.stdenv.mkDerivation {
            name = "default-check";
            src = ./.;
            buildPhase = ''
              touch $out
            '';
          };
        };
    };
}
