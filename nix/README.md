# Nix setup

1. [Install Nix (macOS)](https://nixos.org/manual/nix/stable/#sect-macos-installation)

    ```
    $ sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
    ```

    If this does not work, create the new APFS volume manually (replace "X" in "diskX" with the right disk by using `diskutil list`):

    ```
    sudo diskutil apfs addVolume diskX APFS 'Nix Store' -mountpoint /nix
    ```

    And then run the install command again

2. [Install Home Manager](https://github.com/nix-community/home-manager)

    ```
    # Add the Home Manager channel
    $ nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    $ nix-channel --update

    # Run the Home Manager installation command and create the first Home Manager generation
    $ nix-shell '<home-manager>' -A install
    ```




