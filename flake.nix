# sudo nixos-rebuild --flake .#hostname
{
 description = "flake"; 

 inputs = {
   # Nixpkgs
   nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

   # Home manager
   home-manager.url = "github:nix-community/home-manager";
   home-manager.inputs.nixpkgs.follows = "nixpkgs";

   # Hardware
   hardware.url = "github:nixos/nixos-hardware";
 };

 outputs = { self, nixpkgs, home-manager, ... }@inputs: 
   # NixOS configuration entrypoint
   # Available through 'nixos-rebuild --flake .#your-hostname'
   let
     inherit (self) outputs;
     lib = nixpkgs.lib // home-manager.lib;
     systems = [ "x86_64-linux" "aarch64-linux" ];
     forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
     pkgsFor = lib.genAttrs systems (system: import nixpkgs {
       inherit system;
       config.allowUnfree = true;
     });
     in
     {
       inherit lib;

   nixosConfigurations = {
     # replace below with hostname
     void = lib.nixosSystem {
       specialArgs = { inherit inputs outputs; }; # Pass flake inputs to our config
       # > Our main nixos configuration file <
       modules = [ 
         ./nixos/void/configuration.nix
       ];
     };
     gram = lib.nixosSystem {
       specialArgs = { inherit inputs outputs; }; # Pass flake inputs to our config
       # > Our main nixos configuration file <
       modules = [ 
         ./nixos/gram/configuration.nix
       ];
     };
   };

   # home-manager configuration entrypoint
   # Available through 'home-manager --flake .#your-username@your-hostname'
   homeConfigurations = {
     # replace with your username@hostname
     "grant@void" = lib.homeManagerConfiguration {
       pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
       extraSpecialArgs = { inherit inputs outputs; }; # Pass flake inputs to our config
       # > Our main home-manager configuration file <
       modules = [ 
           ./home-manager/home.nix 
           ];
     };
     "grant@gram" = lib.homeManagerConfiguration {
       pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
       extraSpecialArgs = { inherit inputs outputs; }; # Pass flake inputs to our config
       # > Our main home-manager configuration file <
       modules = [ 
           ./home-manager/home.nix 
           ];
     };
   };
 };
}
