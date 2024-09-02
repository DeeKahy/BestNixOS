{ config, pkgs, lib, inputs, ... }:
let
  stablePkgs = import inputs.stablenixpkgs {
    system = pkgs.system;
    config = { allowUnfree = true; };
  };
in
{
  # Enable experimental Nix features
  nix.settings.experimental-features = "nix-command flakes";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Import necessary configurations
  imports = [
    ./hardware-configuration.nix
    # Comment out Home Manager for now
    # inputs.home-manager.nixosModules.default
  ];

  # User configuration
  users.users.deekahy = {
    isNormalUser = true;
    description = "DeeKahy";
    extraGroups = [ "networkmanager" "wheel" "disk" "audio" ];
    shell = pkgs.nushell;
    packages = with stablePkgs; [
      jetbrains.idea-ultimate
    ];
  };

  # Comment out Home Manager configuration
  # home-manager = {
  #   extraSpecialArgs = { inherit inputs; };
  #   users = {
  #     "deekahy" = import ./home.nix;
  #   };
  # };

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname configuration
  networking.hostName = "nixos";

  # Enable NetworkManager for networking
  networking.networkmanager.enable = true;

  # Set timezone
  time.timeZone = "Europe/Copenhagen";

  # Internationalization settings
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

  # X11 windowing system configuration
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  # Display manager configuration
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware