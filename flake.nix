{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    wezterm.url = "github:wez/wezterm/main?dir=nix";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    fps.url = "github:wamserma/flake-programs-sqlite";
    fps.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, wezterm, ... } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.fps.nixosModules.programs-sqlite
      ];
    };
  };
}
