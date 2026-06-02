{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nvim-config = {
      url = "github:glyphrider/kickstart.nvim";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nvim-config,
      hyprland,
      ...
    }@inputs:
    {
      nixosConfigurations.nixie = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.brian = import ./home.nix;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
}
