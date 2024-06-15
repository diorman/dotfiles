## Updating home-manager

1. Check [releases available](https://nix-community.github.io/home-manager/release-notes.xhtml)
2. Optionally change home manager version in `base/default.nix` (stateVersion)
3. Add channels for the new version
  ```sh
  nix-channel --add https://channels.nixos.org/nixos-24.05 nixpkgs
  nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
  ```
4. Update
  ```
  make update-home-manager
  ```

## Updating nix

From: https://nixos.org/manual/nix/stable/installation/upgrading

```sh
# macOS multi-user
# There's no need to use sudo as mentioned in the docs.
# Note: Try without specifying a channel

nix-env --install --file '<nixpkgs>' --attr nix
sudo launchctl remove org.nixos.nix-daemon
sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
```
