# Edit this configuration
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Enable flakes and nix commands
  nix.settings.experimental-features = "nix-command flakes";
  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.flatpak.enable = true;

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # inputs.home-manager.nixosModules.default
    ./systemconfig/grub.nix
    ./systemconfig/displaymanager.nix
    ./systemconfig/datetime.nix
    ./userconfig/user.nix
  ];
programs.kdeconnect.enable = true;
  boot.kernelPackages = pkgs.linuxPackages;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers = ["nvidia"];


  networking.hostName = "nixos"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  programs.fish.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inputs.self.packages."x86_64-linux".bvim
    steam
    vim
    git
    gh
    teamspeak6-client
    lutris
    obs-studio
    copycat
    bottles
    gparted
    vesktop
    protonup
    alejandra
    github-desktop
    zed-editor
    prismlauncher
    zoxide
    librewolf
    protontricks
  ];
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true; # Should be enabled by default, but good to be explicit
  };

  programs.command-not-found.enable = true; # Disable the default

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
  virtualisation.waydroid.enable = true;

  networking.firewall = {
    enable = false;
    allowedUDPPorts = [11000]; # WireGuard port (adjust if different)
  };

  system.stateVersion = "24.05"; # Did you read the comment?

  # NH program configuration
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/deekahy/BestNixOS";
  };

  # Session variables
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/deekahy/.steam/root/compatibilitytools.d";
    NIXOS_OZONE_WL = "1"; # For Wayland
    NIXPKGS_ALLOW_UNFREE = "1";
  };
}
