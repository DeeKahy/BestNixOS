{ config, pkgs, lib, inputs, ... }:
let
  # Reference the stable nixpkgs
  stablePkgs = import inputs.stablenixpkgs {
    system = pkgs.system;
    config = { allowUnfree = true; };  # If you use any unfree packages
  };
in
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
  # stylix.image = ./yes.png;
  # User configuration
  users.users.deekahy = {
    isNormalUser = true;
    description = "DeeKahy";
    extraGroups = [ "networkmanager" "wheel" "disk" ];
    shell = pkgs.nushell;
    packages = with stablePkgs; [
  
    jetbrains.idea-ultimate
    ];
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
  };

  # Display manager configuration
  services.xserver.displayManager.gdm.enable = true;
  # services.displayManager.gdm.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  # services.xserver.desktopManager.plasma6.enable = true;

hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
# hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
#   version = "555.42.02";
#   sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
#   sha256_aarch64 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
#   openSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
#   settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA="; 
#   persistencedSha256 = lib.fakeSha256;
# };
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
    inputs.nix-software-center.packages.${system}.nix-software-center
    nh
    
    nix-output-monitor
    protonup
    mangohud
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
    # NIXOS_OZONE_WL = "1";
  };

  # System state version
  system.stateVersion = "unstable"; # Did you read the comment?

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
