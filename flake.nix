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
            mkSystem = pkgs: system: hostname:
                pkgs.lib.nixosSystem {
                    system = system;
                    modules = [
                        { networking.hostName = hostname; }
                        /home/dinis/.nixdots/modules/system/configuration.nix
                        ./hosts/${hostname}/hardware-configuration.nix
                        home-manager.nixosModules.home-manager
                        {
                            home-manager = {
                                useUserPackages = true;
                                useGlobalPkgs = true;
                                extraSpecialArgs = { inherit inputs; };
                                users.dinis = /home/dinis/.nixdots/hosts/${hostname}/user.nix;
                            };
                        }
                    ];
                    specialArgs = { inherit inputs; };
                };
        in {
            nixosConfigurations = {
                vm-test = mkSystem inputs.nixpkgs "x86_64-linux" "vm-test";
            };
    };
}