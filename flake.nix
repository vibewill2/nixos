{
  description = "NixOS + Noctalia";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, noctalia, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./configuration.nix

        # módulo do Noctalia
        noctalia.nixosModules.default

        # instala o pacote no sistema
        ({ pkgs, ... }: {
          environment.systemPackages = [
            noctalia.packages.${system}.default
          ];
        })
      ];
    };
  };
}
