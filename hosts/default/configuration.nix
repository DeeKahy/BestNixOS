{ config, pkgs, lib, inputs, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./deekahy.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Basic system settings
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Disable the X11 windowing system and KDE Plasma
  services.xserver.enable = false;
  services.displayManager.sddm.enable = false;

  # Enable Hyprland with Wayland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Correct NVIDIA driver settings
  hardware.nvidia = {
    modesetting.enable = true;
  };

  # System services configuration
  services.printing.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth settings
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Miscellaneous settings
  system.stateVersion = "unstable"; # Keep track of NixOS version compatibility
}
