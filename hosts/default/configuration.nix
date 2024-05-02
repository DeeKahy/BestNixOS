{ config, pkgs, lib, inputs, ... }:

{
  users.users.deekahy = {
    isNormalUser = true;
    description = "DeeKahy";
    extraGroups = [ "networkmanager" "wheel" "disk" ];
    packages = with pkgs; [
    ];

    password = "sunsil";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "deekahy" = import ./home.nix;
    };
  };

  nix.settings.experimental-features = "nix-command flakes";
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
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

# Enable the X11 windowing system.
  services.xserver.enable = true;

# Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "deekahy";

  services.xserver.desktopManager.plasma5.enable = true;
  services.displayManager.sddm.wayland.enable = true;

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

  environment.interactiveShellInit = ''
    eval "$(zoxide init bash --cmd z)"
    alias cd="z"
    alias ls="eza"
    '';

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

programs.gamemode.enable = true;
  programs.kdeconnect.enable = true; 

  nixpkgs.config.allowUnfree = true;

# programs.hyprland = {
#   enable = true;
#   xwayland.enable = true;
# };
# environment.sessionVariables = {
#   # WLR_NO_HARDWARE_CURSORS = "1";
#   NIXOS_OZONE_WL = "1";
# };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  environment.variables = {
    JAVA_HOME = "/nix/store/jnvh76s6vrmdd1rnzjll53j9apkrwxnc-openjdk-21+35";
  };
  
  environment.systemPackages = with pkgs; [
    nh
    nix-output-monitor
    nvd
    # waybar
#     (waybar.overrideAttrs (oldAttrs: {
#     mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
#   })
# )
    # dunst
    # libnotify
    # swww
    # kitty
    protonup
    # rofi-wayland
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/deekahy/dotfiles/nixos";
  };
  environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/deekahy/.steam/root/compatibilitytools.d";
    };

  system.stateVersion = "unstable"; # Did you read the comment?
    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
}

