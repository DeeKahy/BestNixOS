{ config, pkgs, ... }:

{
  
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "deekahy";
  home.homeDirectory = "/home/deekahy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "jetbrains-mono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   eco "Hello, ${config.home.username}!"

    # '')

    # applications
    firefox
    kate
    neovim
    thunderbird
    github-desktop
    kcalc
    filezilla
    vscode
    
    # gaming
    steam
    heroic
    lutris

    # vesktop
    # dorion
    armcord
    bottles
    prismlauncher
    obs-studio
    mpv


    # terminal tools
    tree
    git
    gh
    eza
    bat
    zoxide # very cool cd alternative
    fastfetch
    nushell # An interesting bash alternative
    starship # the prompt manager that makes it look fancy
    carapace # Auto completion for the shell
    python3

# dumb dependencies
    gcc
    xsel
    cargo

    dotnetCorePackages.sdk_6_0_1xx
    sidequest
    blueman
   libreoffice-qt6-still
   temurin-jre-bin-8
   abaddon

# fun
  qjackctl
  pdfarranger
  xautoclick
  jetbrains.rust-rover
  pkg-config
  pkgs.openssl.dev
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose

    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/deekahy/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  


  programs = {
    nushell = { enable = true;
# The config.nu can be anywhere you want if you like to edit your Nushell with Nu
      configFile.source = ./config.nu;
# for editing directly to config.nu 
      extraConfig = ''
        let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
        }
      $env.config = {
show_banner: false,
             completions: {
case_sensitive: false # case-sensitive completions
                  quick: true    # set to false to prevent auto-selecting completions
                  partial: true    # set to false to prevent partial filling of the prompt
                  algorithm: "fuzzy"    # prefix or fuzzy
                  external: {
# set to false to prevent nushell looking into $env.PATH to find more suggestions
enable: true 
# set to lower can improve completion performance at the cost of omitting some options
          max_results: 100 
          completer: $carapace_completer # check 'carapace_completer' 
                  }
             }
      } 
      $env.PATH = ($env.PATH | 
          split row (char esep) |
          prepend /home/myuser/.apps |
          append /usr/bin/env
          )
        '';
      shellAliases = {
        vi = "nvim";
        vim = "nvim";
# nano = "hx";
        cd = "z";
      };
    };  
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = { enable = true;
      settings = {
        add_newline = true;
        character = { 
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
