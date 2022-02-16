{ pkgs, ... }:

let
  pinentry = pkgs.pinentry_mac;
  pinentryPath = "${pinentry}/${pinentry.binaryPath}";

in {
  programs.gpg.enable = true;
  home.file.".gnupg/gpg-agent.conf".text = "pinentry-program ${pinentryPath}";
  home.packages = [ pinentry ];
}
