{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    # enableCompletion = true;
};
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
