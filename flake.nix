{
  description = "My NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations = {
      void = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };
	      modules = [ 
	        ./hosts/void/configuration.nix 
	      ];
      };
      gram = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };
	      modules = [ 
	        ./hosts/gram/configuration.nix 
	      ];
      };
    };
      
    devShells = {
      ${system} = {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.python313
            pkgs.python313Packages.tkinter
            pkgs.python313Packages.virtualenv
          ];
          shellHook = ''
            if [ ! -d .venv ]; then
              python -m venv .venv
            fi
            source .venv/bin/activate
            echo "Activated virtual environment at .venv"
          '';
        };
      };
    };
  };
}
