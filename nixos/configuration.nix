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
  # boot.kernelPackages = pkgs.linuxPackages_6_11;
  boot.kernelPackages = pkgs.linuxPackages;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.nameservers = ["1.1.1.1"];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.fish.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    # bambu-studio
    inputs.self.packages."x86_64-linux".bvim
    steam
    vim
    git
    gh
    brave
    # sqlite
    lutris
    vlc
    obs-studio
    legcord
    copycat
    bottles
    # bend
    # hvm
    # pcmanfm
    gparted
    kdiskmark
    vesktop
    protonup
    ghostty
    alejandra
    neovim
    github-desktop
    zed-editor
    gcc
    inputs.zen-browser.packages."${system}".default # beta
    signal-desktop
    rpi-imager
    prismlauncher
    distrobox
    boxbuddy
    zoxide
    xclip
    wl-clipboard
    cliphist
    rust-analyzer
    protonmail-desktop
    mullvad-browser
    librewolf
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
  # virtualisation.lxd.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = {
    enable = true;
    # allowedUDPPorts = [51820]; # WireGuard port (adjust if different)
    # allowPing = true; # Allows incoming ICMP echo requests
    # For explicit outbound ICMP (usually allowed by default)
    # extraCommands = ''
    #   iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
    # '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
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
    #   MOZ_X11_EGL = "1";
    # MOZ_ENABLE_WAYLAND = "1"; # If using Wayland
    #   LIBVA_DRIVER_NAME = "nvidia"; # For NVIDIA GPUs, or "iHD" for Intel, "radeonsi" for AMD
    # WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1"; # For Wayland
    NIXPKGS_ALLOW_UNFREE = "1";
  };
  virtualisation.docker.enable = true;
}
