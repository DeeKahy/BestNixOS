{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stablenixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    mynixpkgs.url = "github:DeeKahy/nixpkgs/master";
    # fps.url = "github:wamserma/flake-programs-sqlite";
    # fps.inputs.nixpkgs.follows = "nixpkgs";
    # nixpkgs.follows = "nixos-cosmic/nixpkgs"; # NOTE: change "nixpkgs" to "nixpkgs-stable" to use stable NixOS release
    # nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    # home-manager = {
    #  url = "github:nix-community/home-manager";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = {
    self,
    nixpkgs,
    # nixos-cosmic,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        #  {
        #   nix.settings = {
        #     substituters = ["https://cosmic.cachix.org/"];
        #     trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
        #   };
        # }
        ./nixos/configuration.nix
        # nixos-cosmic.nixosModules.default
        # inputs.home-manager.nixosModules.default
        # inputs.fps.nixosModules.programs-sqlite
      ];
    };
  };
}
