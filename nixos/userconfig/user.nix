{
  pkgs,
  inputs,
  ...
}: let
  stablePkgs = import inputs.stablenixpkgs {
    system = pkgs.system;
    config = {allowUnfree = true;};
  };

  myPkgs = import inputs.mynixpkgs {
    system = pkgs.system;
    config = {allowUnfree = true;};
  };
in {
  users.users.deekahy = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "deekahy";
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
    packages = with stablePkgs;
      [
        bambu-studio
        blender
        davinci-resolve-studio
        wl-clipboard
        xclip
        nixd
        nil
        thunderbird
        vscode
      ];
  };

}
