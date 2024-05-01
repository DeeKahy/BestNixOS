
{ config, pkgs, lib, inputs, ... }:

{
  users.users.deekahy = {
    isNormalUser = true;
    description = "DeeKahy";
    extraGroups = [ "networkmanager" "wheel" "disk" ];
    packages = with pkgs; [
    ];

    password = "sunsil";
  };

home-manager = {
  extraSpecialArgs = { inherit inputs; };
  users = {
      "deekahy" = import ./home.nix;
    };
};


  environment.interactiveShellInit = ''
    eval "$(zoxide init bash --cmd z)"
    alias cat="bat"
    alias cd="z"
    alias ls="eza"
  '';

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };



  programs.kdeconnect.enable = true; 

  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  environment.variables = {
    JAVA_HOME = "/nix/store/jnvh76s6vrmdd1rnzjll53j9apkrwxnc-openjdk-21+35";
    FLAKE = "/home/deekahy/dotfiles/nixos";
  };
  environment.systemPackages = with pkgs; [
  nh
  ];
}
