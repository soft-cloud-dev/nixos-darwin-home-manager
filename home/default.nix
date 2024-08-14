{ pkgs, inputs, ... }:
{
  # Import configurations
  imports = [
    ./squid.nix
    ./adguardhome.nix
    ./nix-index.nix
  ];

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
      automatic = true; # Enable automatic garbage collection
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
    python3
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
    # Custom Python package
    (python3Packages.buildPythonPackage rec {
      pname = "xontrib-vox";
      version = "0.0.1";
      src = fetchFromGitHub {
        owner = "xonsh";
        repo = "xontrib-vox";
        rev = "0.0.1";
        hash = "sha256-OB1O5GZYkg7Ucaqak3MncnQWXhMD4BM4wXsYCDD0mhk=";
      };
      prePatch = ''
        substituteInPlace pyproject.toml --replace '"xonsh>=0.12.5"' ""
      '';
      meta = with lib; {
        description = "Direnv support for Xonsh";
        homepage = "https://github.com/74th/xonsh-direnv/";
        license = licenses.mit;
        maintainers = [ ];
      };
      patchPhase = "sed -i -e 's/^dependencies.*$/dependencies = []/' pyproject.toml";
      doCheck = false;
      nativeBuildInputs = [ git ];
    })
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
      userName = "Lukasz";
      userEmail = "lukasz@tulikowski.email";
      aliases = {
        co = "checkout";
        ci = "commit";
        st = "status";
        br = "branch";
      };
    };
  };

  # Xonsh configuration
  home.file.".xonshrc".text = ''
    execx($(${pkgs.any-nix-shell}/bin/any-nix-shell xonsh --info-right))
    execx($(${pkgs.zoxide}/bin/zoxide init xonsh))
    aliases['update'] = 'home-manager switch'
  '';

  # Shell aliases
  home.shellAliases = {
    xonsh = "${pkgs.xonsh}/bin/xonsh";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable AdGuard Home service
  services.adguardhome.enable = true;
}
