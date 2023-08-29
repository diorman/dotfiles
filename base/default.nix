{ pkgs, ... }:

let
  settings = import ../settings.nix;
  devenv = (import (builtins.fetchTarball https://github.com/cachix/devenv/archive/v0.6.2.tar.gz)).default;
in
{
  home = {
    stateVersion = "23.05";

    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";

    sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
      CODEPATH = settings.codePath;
    } // settings.sessionVariables;

    packages = with pkgs; [
      awscli2 # Unified tool to manage your AWS services
      bat # A cat clone with syntax highlighting and Git integration
      coreutils # The basic file, shell and text manipulation utilities of the GNU operating system
      curl # A command line tool for transferring files with URL syntax
      devenv # Fast, Declarative, Reproducible, and Composable Developer Environments using Nix
      findutils # GNU Find Utilities, the basic directory searching utilities of the GNU operating system
      fzf # A command-line fuzzy finder written in Go
      gawk # GNU implementation of the Awk programming language
      gnugrep # GNU implementation of the Unix grep command
      gnumake # A tool to control the generation of non-source files from sources
      gnused # GNU sed, a batch stream editor
      gnutar # GNU implementation of the `tar' archiver
      go # The Go Programming language
      jq # A lightweight and flexible command-line JSON processor
      k9s # Kubernetes CLI To Manage Your Clusters In Style
      kubectl # Kubernetes CLI
      kubectx # Fast way to switch between clusters and namespaces in kubectl!
      lazygit # Simple terminal UI for git commands
      niv # Easy dependency management for Nix projects
      nodejs # Event-driven I/O framework for the V8 JavaScript engine
      openssl # A cryptographic library that implements the SSL and TLS protocols
      python3 # A high-level dynamically-typed programming language
      ripgrep # Line-oriented search tool that recursively searches the current directory for a regex pattern
      rustup # The Rust toolchain installer
      shellcheck # Shell script analysis tool
      tmate # Instant Terminal Sharing
      tree # Command to produce a depth indented directory listing
      unixtools.watch # Executes a program periodically, showing output fullscreen
    ];
  };

  programs = {
    home-manager.enable = true;

    # A shell extension that manages your environment
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  # workaround for https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false;
}
