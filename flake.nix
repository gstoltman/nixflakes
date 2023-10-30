{
  description = "Machine specific configuration flake.";
  # Defining package channels
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
    };
  };
  
  # Defining flake import structure for packages
  outputs = { self, nixpkgs, ... } @ attrs: { 
    
  # Appended new system
    nixosConfigurations.gram = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
            username = "grant";
            hostname = "gram";
            displayConfig = "1monitor";
            nvidia_bool = "disabled";
        } // attrs;        
        modules = [
              ./.
          ];
    };#gram

  };
}
