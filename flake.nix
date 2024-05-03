{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      packageOverrides = pkgs.callPackage ./python-packages.nix { };
      python = pkgs.python3.override { inherit packageOverrides; };
      pythonWithPackages = python.withPackages (ps: [ ps.tyro ]);
    in rec {
      packages.shaman = pkgs.writeScriptBin "shaman" ''
        ${pythonWithPackages}/bin/python3 ${self}/shaman
      '';

      apps.default = {
        type = "app";
        program = "${self.packages.${system}.shaman}/bin/shaman";
      };

      devShell = pkgs.mkShell {
        buildInputs = [ pythonWithPackages ];
      };
    }
  );
}
