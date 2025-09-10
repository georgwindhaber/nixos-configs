{ }:
{
  # inputs.sops-nix.url = "github:Mic92/sops-nix";
  # inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  # outputs =
  #   {
  #     self,
  #     nixpkgs,
  #     sops-nix,
  #   }:
  #   {
  #     nixosConfigurations.metal-server = nixpkgs.lib.nixosSystem {
  #       system = "x86_64-linux";
  #     };
  #   };
}
