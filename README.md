## Updating home-manager

1. Check [releases available](https://nix-community.github.io/home-manager/release-notes.html)
2. Change home manager version in `base/default.nix` (stateVersion)
3. Add the the nix channel for the new version
  ```sh
  nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
  ```
4. Update
  ```
  make update-home-manager
  ```
