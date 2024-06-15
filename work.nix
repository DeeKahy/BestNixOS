{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    slack
    awscli2
    cargo-lambda
    gnumake
    cmake
  ];
}
