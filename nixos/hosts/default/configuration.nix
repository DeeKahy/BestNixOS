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

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
      cd = "z";
      # Add more aliases here
    };
  };

  # User configuration
  users.users.deekahy = {
    isNormalUser = true;
    description = "DeeKahy";
    extraGroups = [ "networkmanager" "wheel" "disk" "audio" ];
    shell = pkgs.fish;
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
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  #   # enableKwallet = true;
  # };
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

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
  # services.printing.enable = true;

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


  services.flatpak.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # System and Package Management
    nh
    nix-output-monitor
    protonup
    gparted
    fontconfig
    cudaPackages_12_2.cudatoolkit
    appimage-run
    glibc
  
    # Development Tools
    git
    gh
    nodejs
    python3
    rustc
    cargo
    gcc
    dotnetCorePackages.sdk_6_0_1xx
    nixd
    selenium-server-standalone
    php83Packages.php-codesniffer
  
    # Text Editors and IDEs
    neovim
    zed-editor
    vscode
    kate
    jetbrains.phpstorm
  
    # Terminal Utilities
    fish
    inputs.wezterm.packages.${pkgs.system}.default
    tree
    eza
    bat
    zoxide
    fastfetch
    xclip
  
    # File Management and Utilities
    unzip
    copycat
    wl-clipboard
    filezilla
  
    # Browsers and Communication
    firefox-devedition-bin
    vesktop
  
    # Multimedia
    obs-studio
    handbrake
    mpv
    ffmpeg
    
  
    # Gaming
    steam
    heroic
    lutris
    bottles
    prismlauncher
    mangohud
    # factorio
  
    # Office and Productivity
    obsidian
    pdfarranger
  
    # System Utilities
    blueman
  
    # Audio
    qjackctl
  
    # Version Control and Collaboration
    github-desktop
  
    # Miscellaneous
  ];

  # NH program configuration
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/deekahy/dotfiles";
  };

  programs.adb.enable = true;

  # Session variables
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/deekahy/.steam/root/compatibilitytools.d";
 #   MOZ_X11_EGL = "1";
    # MOZ_ENABLE_WAYLAND = "1"; # If using Wayland
 #   LIBVA_DRIVER_NAME = "nvidia"; # For NVIDIA GPUs, or "iHD" for Intel, "radeonsi" for AMD
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1"; # For Wayland
  };

  # System state version
  system.stateVersion = "23.11";

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
