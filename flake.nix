{
    description = "My first flake!";

    inputs = {
        hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nur.url = "github:nix-community/NUR";
        catppuccin-starship = {
            url = "github:catppuccin/starship";
            flake = false;
        };
        nix-alien.url = "github:thiagokokada/nix-alien";
        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { hyprland, nixpkgs, home-manager, nur, nix-alien, nixvim, self, ... }@inputs:
        let
            system = "x86_64-linux";
            mkSystem = pkgs: system: hostname:
                pkgs.lib.nixosSystem {
                    system = system;
                    modules = [
                        { networking.hostName = hostname; }
                        { environment.variables.HOSTNAME = hostname; }
                        { nixpkgs.config.allowUnfree = true; }
                        { nixpkgs.overlays = [ inputs.nix-alien.overlays.default ]; }
                        ./modules/core/configuration.nix
                        ./hosts/${hostname}/hardware-configuration.nix
                        home-manager.nixosModules.home-manager
                        {
                            home-manager = {
                                useUserPackages = true;
                                useGlobalPkgs = true;
                                sharedModules = [
                                    nixvim.homeManagerModules.nixvim
                                ];
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