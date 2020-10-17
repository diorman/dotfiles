{ config, pkgs, ... }:

let
  userDir = if pkgs.stdenv.hostPlatform.isDarwin then
    "Library/Application Support/Code/User"
  else
    "${config.xdg.configHome}/Code/User";

  configFilePath = "${userDir}/settings.json";

in {
  home.file."${configFilePath}".source = config.lib.file.mkOutOfStoreSymlink ./settings.json;
}
