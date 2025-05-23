{
  description = "NixOS configuration";

  # All inputs for the system
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  # All outputs for the system (configs)
  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      vscode-server,
      ...
    }@inputs:
    let
      # This lets us reuse the code to "create" a system
      # Credits go to sioodmy on this one!
      # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
      mkSystem =
        pkgs: system: hostname:
        pkgs.lib.nixosSystem {
          system = system;
          modules = [
            vscode-server.nixosModules.default
            { networking.hostName = hostname; }
            ./modules/system
            (./. + "/hosts/${hostname}/hardware-configuration.nix")
            (./. + "/hosts/${hostname}/host.nix")
            {
              nixpkgs.overlays = [
                (final: prev: {
                  stable = import inputs.nixpkgs-stable {
                    system = final.system;
                    config.allowUnfree = true;
                  };
                })
              ];
              nixpkgs.config.allowUnfree = true;
            }
          ];

          specialArgs = {
            inherit inputs;
          };
        };
    in
    {
      nixosConfigurations = {
        aspire = mkSystem inputs.nixpkgs "x86_64-linux" "aspire";
      };
    };
}
