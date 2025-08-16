{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

	outputs = { self, nixpkgs }: {
    nixosConfigurations.steam-machine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/steam-machine/configuration.nix ];
    };
    nixosConfigurations.metal-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/metal-server/configuration.nix ];
    };
  };
}
