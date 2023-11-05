{
    description = "My first flake!";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs, ... }: 
        let 
            lib = nixpkgs.lib;
        in {
        nixosConfigurations = {
            vm-test = lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./hosts/vm-test/configuration.nix
                ];
            };
        };
    };
}