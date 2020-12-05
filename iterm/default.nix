{ config, ... }:

{
  home.file.".config/iterm/com.googlecode.iterm2.plist".source = config.lib.file.mkOutOfStoreSymlink ./com.googlecode.iterm2.plist;
}
