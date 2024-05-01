{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set root password (optional, if you need to reset it)
  users.users.root.password = "newrootpassword";

  # Ensure the user 'deekahy' is correctly set up
  users.users.deekahy = {
    isNormalUser = true;
    home = "/home/deekahy";
    password = "sunsil";
  };

  # Enable a graphical environment: Xfce
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # Basic system settings
  system.stateVersion = "unstable";
}
