
{ config, pkgs, lib, ... }:

{

# # Enable the KDE Plasma Desktop Environment.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "deekahy";
  
  services.xserver.desktopManager.plasma6.enable = true;
  # services.xserver.displayManager.defaultSession = "plasma";
  }
  
