{ pkgs, ... }:

let
  settings = import ../settings.nix;

in {
  home.sessionVariables = {
    EDITOR = "vim";
    VEDITOR = "code";
    CODEPATH = settings.codePath;
  } // settings.sessionVariables;

  programs = {
    home-manager.enable = true;

    # A shell extension that manages your environment
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # shell prompt
    starship.enable = true;
  };

  home.packages = with pkgs; [
    awscli2 # Unified tool to manage your AWS services
    bash # GNU Bourne-Again Shell, the de facto standard shell on Linux
    bat # A cat clone with syntax highlighting and Git integration
    coreutils # The basic file, shell and text manipulation utilities of the GNU operating system
    curl # A command line tool for transferring files with URL syntax
    findutils # GNU Find Utilities, the basic directory searching utilities of the GNU operating system
    fzf # A command-line fuzzy finder written in Go
    gawk # GNU implementation of the Awk programming language
    gnugrep # GNU implementation of the Unix grep command
    gnumake # A tool to control the generation of non-source files from sources
    gnused # GNU sed, a batch stream editor
    gnutar # GNU implementation of the `tar' archiver
    jq # A lightweight and flexible command-line JSON processor
    k9s # Kubernetes CLI To Manage Your Clusters In Style
    kubectl # Kubernetes CLI
    kubectx # Fast way to switch between clusters and namespaces in kubectl!
    niv # Easy dependency management for Nix projects
    openssl # A cryptographic library that implements the SSL and TLS protocols
    python3 # A high-level dynamically-typed programming language
    rustup	# The Rust toolchain installer
    shellcheck # Shell script analysis tool
    tmate # Instant Terminal Sharing
    tree # Command to produce a depth indented directory listing
    unixtools.watch # Executes a program periodically, showing output fullscreen
    vim # The most popular clone of the VI editor
  ];
}
