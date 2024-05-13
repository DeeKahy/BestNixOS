{ config, pkgs, lib, inputs, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";
  #import shit
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
   # ./kde.nix
    ];

# my user
  users.users.deekahy = {
    isNormalUser = true;
    description = "DeeKahy";
    extraGroups = [ "networkmanager" "wheel" "disk" ];
    packages = with pkgs; [
    ];

  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "deekahy" = import ./home.nix;
    };
  };


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

# Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver = {
  enable = true;
  layout = "us";
  displayManager.sessionCommands = ''
    # Set up monitors with appropriate refresh rates
    xrandr --output DP-2 --mode 2560x1440 --rate 143.91
    xrandr --output HDMI-2 --mode 1920x1080 --rate 60.00
  '';
};
  services.displayManager.sddm.enable = true;

  services.xserver.desktopManager.plasma6.enable = true;

# Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

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

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
 programs.gamemode.enable = true;

  programs.kdeconnect.enable = true; 

  nixpkgs.config.allowUnfree = true;


  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
 hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  services.xserver.videoDrivers = [ "nvidia" ];
  # services.xserver.videoDrivers = [ "nvd" ];

  hardware.nvidia.modesetting.enable = true;

  # programs.nix-ld.libraries = with pkgs; [];

  # fonts.packages = with pkgs; [
    # (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  # ];

  environment.systemPackages = with pkgs; [
    nh
      nix-output-monitor
      protonup
      mangohud
      libsForQt5.qtstyleplugin-kvantum
    # (pkgs.nerdfonts.override { fonts = [ "jetbrains-mono" ]; })
    # nvd
    xorg.xrandr
    arandr
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/deekahy/dotfiles/nixos";
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/deekahy/.steam/root/compatibilitytools.d";
    JAVA_HOME = "/nix/store/jnvh76s6vrmdd1rnzjll53j9apkrwxnc-openjdk-21+35";
    NIXOS_OZONE_WL = "1";
# SDL_VIDEODRIVER = "wayland";
  };

  system.stateVersion = "unstable"; # Did you read the comment?
    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
}

