{ config, pkgs, ... }: {
  imports = [ ../hosts/default/configuration.nix ];
  services.xserver.displayManager.waylandEnable = true;
}

