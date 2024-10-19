# NixOS Darwin Home Manager 

- **NixOS:** v2.23.3
- **Home Manager:** v24.05
- **Nixpkgs:** v24.05

Extra addons:
- **Squid proxy** (currently not available on MacOS Silicon - missing binaries) 
- **AdGuardHome** (configuration not yet complete)

## Development Environment Manual (devenv and devbox)

This manual outlines the tools and configurations in your Nix-based development environment, focusing on devenv and devbox.

### Core Components

1. **Nixpkgs**: The primary package collection for Nix.
2. **Home Manager**: Manages user-specific configurations.

### Key Development Tools

#### devenv
devenv is not explicitly listed in your configuration, but if you want to use it, you can add it to your setup. devenv provides reproducible development environments.

#### devbox
Devbox is included in your setup. It's a tool for creating isolated, reproducible development environments.

Usage:
```bash
devbox init    # Initialize a new project
devbox add     # Add a package to your project
devbox shell   # Enter the development environment
```

### Other Development Tools

- **ripgrep**: Fast search tool for recursive searching.
- **fd**: User-friendly alternative to `find`.
- **sd**: Intuitive find & replace CLI.
- **tree**: Displays directory contents in a tree-like format.
- **cachix**: Binary cache for Nix.
- **nil**: Nix language server.
- **nix-info**, **nixpkgs-fmt**, **nixci**, **nix-health**: Various Nix utilities.

### Version Control
- **Git**: Configured with user details and aliases.
- **LazyGit**: Terminal UI for Git commands.

### Programming Languages
- **Python**: 
  - **Poetry**: Dependency management for Python.
- **Node.js**:
  - **node2nix**: Converts Node.js packages to Nix expressions.
  - **nodejs_22**: Node.js version 22.

### Shell and Scripting
- **Bash** and **Zsh**: Configured shells with custom aliases and PATH modifications.
- **Xonsh**: Python-based shell.
- **any-nix-shell**: Allows using Nix shells with any shell.
- **direnv**: Automatically loads and unloads environment variables.

### Proxy and Networking
- **AdGuard Home**: Network-wide ad blocker.

### Configuration Files
- **home/default.nix**: Primary configuration for Home Manager.

### Usage Instructions

1. Edit `home/default.nix` to customize your Home Manager configuration.
2. Run `nix run` to apply the configuration.
3. Use `devbox` to manage project-specific development environments:
   ```bash
   devbox init    # In your project directory
   devbox add python nodejs  # Add required tools
   devbox shell   # Enter the environment
   ```
4. Use `direnv` to automatically load environment variables:
   ```bash
   echo "use devbox" > .envrc
   direnv allow
   ```

### Customization

- Add or modify packages in the `home.packages` section of `home/default.nix`.
- Create project-specific environments using devbox.
- Use direnv to automatically load project environments.

Remember to rebuild your environment after making changes to apply the new configuration:

```bash
just run
```

This setup provides a flexible development environment using devbox for project-specific setups and Home Manager for system-wide configurations. Adjust as needed for your specific development workflows.