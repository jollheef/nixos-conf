# NixOS quick installation checklist for full encrypted root

Based on https://nixos.org/nixos/manual/

## Before install

Download latest NixOS image from https://nixos.org/nixos/download.html and write it to usb flash drive

    $ wget https://d3g5gsiof5omrk.cloudfront.net/nixos/17.09/nixos-17.09.1880.ac2bb5684c/nixos-graphical-17.09.1880.ac2bb5684c-x86_64-linux.iso
    $ sudo dd if=nixos-graphical-17.09.1880.ac2bb5684c-x86_64-linux.iso of=/dev/sdX

then reboot && boot from usb

## Installation

Prepare disk

    # parted /dev/sda
    # (parted) mklabel msdos
    # (parted) mkpart primary ext4 0% 100%
    # (parted) quit

Encrypt it and mount

    # export NIXOS_NAME="thiq" # use you own value and do not forget to change it in configuration.nix
    # cryptsetup luksFormat /dev/sda1
    # cryptsetup luksOpen /dev/sda1  ${NIXOS_NAME}
    # mkfs.ext4 -L ${NIXOS_NAME} /dev/mapper/${NIXOS_NAME}
    # mount /dev/mapper/${NIXOS_NAME} /mnt

Bootstrap minimal NixOS for avoid space issues

    # nix-channel --update
    # nix-env -i git
    # git clone --recursive https://github.com/jollheef/nixos-conf /mnt/etc/nixos
    # nixos-generate-config --root /mnt # generate hardware-configuration.nix
    # cp /mnt/etc/nixos/bootstrap-configuration.nix /mnt/etc/nixos/configuration.nix
    # sed -i "s/thiq/${NIXOS_NAME}/g" /mnt/etc/nixos/configuration.nix # change installation name
    # nixos-install
    # reboot

Continue installation after reboot

    # cd /etc/nixos && git reset --hard
    # sed -i "s/thiq/$(hostname)/g" /etc/nixos/configuration.nix # change installation name
    # vim /etc/nixos/configuration.nix # you must edit some settings like a vpn/wifi support
    # nixos-rebuild switch
    # wpa_passphrase SSID PASSWORD >> /etc/wpa_supplicant.conf # optional but I usually do this
    # reboot # not necessary

Known issues

* I don't know how /etc/nixos/files does updated, so if you change something or display-manager.service does not start -- just rename files in /etc/nixos/files and relevant lines in the configuration.nix.
