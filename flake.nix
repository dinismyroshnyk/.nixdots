{
    description = "My first flake!";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {nixpkgs, home-manager, ... }@inputs: 
        let 
            system = "x86_64-linux";
            pkgs = inputs.nixpkgs.legacyPackages.${system};
            lib = pkgs.lib;
            userConfig = import ./modules/system/user.nix { inherit pkgs; };
            hostname = userConfig.hostname;
            username = userConfig.username;
            mkSystem = pkgs: system: hostname: username:
                pkgs.lib.nixosSystem {
                    system = system;
                    modules = [
                        { networking.hostName = hostname; }
                        ./modules/system/configuration.nix
                        ./hosts/${hostname}/hardware-configuration.nix
                        home-manager.nixosModules.home-manager
                        {
                            home-manager = {
                                useUserPackages = true;
                                useGlobalPkgs = true;
                                extraSpecialArgs = { inherit inputs; };
                                users.${username} = ./hosts/${hostname}/user.nix;
                            };
                        }
                    ];
                    specialArgs = { inherit inputs; };
                };
        in {
            nixosConfigurations = {
                "${hostname}" = mkSystem nixpkgs system hostname username;
            };
    	};
}
