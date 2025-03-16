{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Bootloader configuration
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = false; # Disable systemd-boot

    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true; # Automatically find other operating systems
      theme = pkgs.fetchFromGitHub {
        owner = "shvchk";
        repo = "fallout-grub-theme";
        rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
        sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
      };
    };
  };
}
