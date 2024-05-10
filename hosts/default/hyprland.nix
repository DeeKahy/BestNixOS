
{ config, pkgs, lib, ... }:

{

programs.hyprland = {
  enable = true;
  xwayland.enable = true;
};
environment.sessionVariables = {
  WARP_ENABLE_WAYLAND = 1;
  WLR_NO_HARDWARE_CURSORS = "1";
  NIXOS_OZONE_WL = "1";
};

  environment.systemPackages = with pkgs; [
    waybar
    (waybar.overrideAttrs (oldAttrs: {
    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  })
)
    dunst
    libnotify
    swww
    kitty
    wofi
    dolphin
    alacritty
  ];

  }
  
