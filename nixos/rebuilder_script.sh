#!/usr/bin/env bash

# Enable debugging
set -x

# Exit on error
set -e

# Set the working directory explicitly
cd ~/BestNixOS/ || { echo "Failed to cd into ~/BestNixOS/"; exit 1; }

# Start zeditor and capture its PID
zeditor . --foreground

# Format with Alejandra
alejandra . || { echo "Alejandra formatting failed"; exit 1; }

# Show git diff
git diff -U0 *.nix || { echo "Git diff failed"; exit 1; }

echo "NixOS Rebuilding with nh..."

# Use nh os switch without sudo (nh handles sudo internally)
nh os switch . &>nixos-switch.log || (
  cat nixos-switch.log
  echo "nh os switch failed"
  exit 1
)


# Get the current generation
gen=$(nh os list-generations | grep current)


# Commit changes with the generation message
git commit -am "$gen" || { echo "Git commit failed"; exit 1; }


echo "Rebuild and commit completed successfully!"
read -n 1 -s -r -p "Press any key to continue..."