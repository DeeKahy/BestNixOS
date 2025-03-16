{
  config,
  pkgs,
  inputs,
  ...
}: {
# Enable the X11 windowing system.
# You can disable this if you're only using the Wayland session.
services.xserver.enable = true;
# Enable the KDE Plasma Desktop Environment.
services.displayManager.sddm.enable = true;
# services.displayManager.cosmic-greeter.enable = true;
# services.displayManager.gdm.enable = true;
# services.xserver.desktopManager.gnome.enable = true;
services.desktopManager.plasma6.enable = true;
# services.desktopManager.cosmic.enable = true;
# Resolve the conflict for `ssh-askpass`
# programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
}