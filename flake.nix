{
  description = "Yoyoki's NixOS Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    vscode-remote-workaround.url = "github:K900/vscode-remote-workaround/main";
  };
  outputs = inputs@{ self, nixpkgs, home-manager, nixos-wsl, vscode-remote-workaround, ... }: {
    nixosConfigurations = {
      machine = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machine/configuration.nix
          home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.yoyoki = import ./machine/home.nix;
	        home-manager.extraSpecialArgs = inputs;
          }
        ];
      };
      wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs;};
        modules = [
          nixos-wsl.nixosModules.default
          vscode-remote-workaround.nixosModules.default
	        ./wsl/configuration.nix
          {
            system.stateVersion = "24.05";
            wsl.enable = true;
          }
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yoyoki = import ./wsl/home.nix;
	    home-manager.extraSpecialArgs = inputs;
          }
        ];
      };
    };
  };
}
