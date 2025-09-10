{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      self,
      nixpkgs,
      sops-nix,
    }:
    {
      nixosConfigurations.steam-machine = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/steam-machine/configuration.nix ];
      };
      nixosConfigurations.metal-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/metal-server/configuration.nix
          # sops-nix.nixosModules.sops
        ];
      };
    };
}
