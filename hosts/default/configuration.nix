{ config, pkgs, lib, inputs, ... }:
let
  stablePkgs = import inputs.stablenixpkgs {
    system = pkgs.system;
    config = { allowUnfree = true; };
  };
  zen-browser = pkgs.callPackage ./zenbrowser.nix {};
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

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "deekahy" = import ./home.nix;
    };
  };

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

  # security.pam.services."wayland".enableKwallet = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;

  # Enable CUPS for printing
  services.printing.enable = true;

  # Enable sound with PipeWire
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
  };

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Enable GameMode
  programs.gamemode.enable = true;

  # Enable KDE Connect
  programs.kdeconnect.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # OpenGL hardware acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libva
      libva-utils
      libvdpau-va-gl
      ffmpeg
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    nh
    nix-output-monitor
    protonup
    mangohud
    gparted
    fontconfig
    cudaPackages_12_2.cudatoolkit
    copycat
    wl-clipboard
    zen-browser
  ];

  # NH program configuration
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/deekahy/dotfiles/nixos";
  };

  programs.adb.enable = true;

  # Session variables
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/deekahy/.steam/root/compatibilitytools.d";
    MOZ_X11_EGL = "1";
    MOZ_ENABLE_WAYLAND = "1"; # If using Wayland
    LIBVA_DRIVER_NAME = "nvidia"; # For NVIDIA GPUs, or "iHD" for Intel, "radeonsi" for AMD
  };

  # System state version
  system.stateVersion = "23.11";

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
