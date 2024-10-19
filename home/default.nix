{ pkgs, inputs, ... }:

{
  # Set the state version
  home.stateVersion = "24.05";

  # Recommended Nix settings
  nix = {
    registry = {
      nixpkgs = {
        flake = {
          outPath = inputs.nixpkgs;
        };
      };
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  # Define packages to install
  home.packages = with pkgs; [
    # Development tools
    devbox
    direnv
    git
    gh
    lazygit
    nodejs_22
    python311
    poetry
    cachix
    nil
    nixpkgs-fmt
    nix-info
    nixci
    nix-health
    # File and text manipulation
    ripgrep
    fd
    sd
    tree
    bat
    # Navigation and shell enhancements
    fzf
    zoxide
    btop
    any-nix-shell
    # Graphviz for dot
    graphviz
    # Azure CLI
    azure-cli
    azure-functions-core-tools
    # Typescript
    typescript
    # AI/ML
    ollama
    llm
    python311Packages.numpy
    python311Packages.scipy
    python311Packages.matplotlib
    python311Packages.pandas
    python311Packages.requests
  ];

  # Programs natively supported by home-manager
  programs = {
    bash = {
      enable = true;
      initExtra = ''
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
      '';
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
      '';
    };
    bat.enable = true;
    zoxide.enable = true;
    fzf.enable = true;
    jq.enable = true;
    btop.enable = true;
    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global = {
        hide_env_diff = true; # Make direnv messages less verbose
      };
    };
    git = {
      enable = true;
      userName = "Lukasz Tulikowski";
      userEmail = "lukasz@tulikowski.email";
      aliases = {
        co = "checkout";
        ci = "commit";
        st = "status";
        br = "branch";
      };
    };
  };

  # Shell aliases
  home.shellAliases = {
    # Add your aliases here
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
