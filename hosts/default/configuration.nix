{ config, pkgs, lib, inputs, ... }:

{
  # Enable experimental Nix features
  nix.settings.experimental-features = "nix-command flakes";

  # Import necessary configurations
  imports = [
    ./hardware-configuration.nix          # Include hardware configuration
    inputs.home-manager.nixosModules.default # Home Manager module
    # ./nvidia.nix                         # NVIDIA configuration (commented out)
    # ./kde.nix                            # KDE configuration (commented out)
  ];

  # User configuration
  users.users.deekahy = {
    isNormalUser = true;
    description = "DeeKahy";
    extraGroups = [ "networkmanager" "wheel" "disk" ];
    packages = with pkgs; [ ];
  };

  # Home Manager configuration
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
    layout = "us";
    displayManager.sessionCommands = ''
      # Set up monitors with appropriate refresh rates
      xrandr --output DP-0 --mode 2560x1440 --rate 143.91
      xrandr --output HDMI-0 --mode 1920x1080 --rate 60.00
    '';
  };

  # Display manager configuration
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  # Video driver configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  # services.xserver.videoDrivers = [ "nvd" ];  # Alternative driver (commented out)
    hardware.nvidia.modesetting.enable = true;
  # X11 keymap configuration
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  # Enable CUPS for printing
  services.printing.enable = true;

  # Enable sound with PipeWire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    nh
    
    waydroid
    nix-output-monitor
    protonup
    mangohud
    libsForQt5.qtstyleplugin-kvantum
    xorg.xrandr
    arandr
gparted
  ];
  # NH program configuration
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/deekahy/dotfiles/nixos";
  };

virtualisation.waydroid.enable = true;
  # Session variables
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/deekahy/.steam/root/compatibilitytools.d";
    JAVA_HOME = "/nix/store/jnvh76s6vrmdd1rnzjll53j9apkrwxnc-openjdk-21+35";
    NIXOS_OZONE_WL = "1";
  };

  # System state version
  system.stateVersion = "unstable"; # Did you read the comment?

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
