{
    description = "My first flake!";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nur.url = "github:nix-community/NUR";
    };

    outputs = {nixpkgs, home-manager, nur, ... }@inputs:
        let
            system = "x86_64-linux";
            mkSystem = pkgs: system: hostname:
                pkgs.lib.nixosSystem {
                    system = system;
                    modules = [
                        { networking.hostName = hostname; }
                        { environment.variables.HOSTNAME = hostname; }
                        { nixpkgs.config.allowUnfree = true; }
                        ./modules/core/configuration.nix
                        ./hosts/${hostname}/hardware-configuration.nix
                        home-manager.nixosModules.home-manager
                        {
                            home-manager = {
                                useUserPackages = true;
                                useGlobalPkgs = true;
                                extraSpecialArgs = { inherit inputs; };
                                users.dinis = ./hosts/${hostname}/user-config.nix;
                            };
                            nixpkgs.overlays = [ nur.overlay ];
                        }
                    ];
                    specialArgs = { inherit inputs; };
                };
        in {
            nixosConfigurations = {
                omen-15 = mkSystem nixpkgs system "omen-15";
            };
    	};
}
