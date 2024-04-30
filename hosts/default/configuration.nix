{ config, pkgs, lib, inputs, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./deekahy.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
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

  # Configure X11 and SDDM
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    displayManager = {
      sddm = {
        enable = true;
      };
    };

    desktopManager = {
      plasma5 = {
        enable = true;
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  system.stateVersion = "unstable"; # Confirm you understand the implications
  hardware.bluetooth.enable = true; # Enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # Powers up the default Bluetooth controller on boot
}
