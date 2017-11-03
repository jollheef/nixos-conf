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

Installation

    # nix-channel --update
    # nix-env -i git
    # git clone --recursive https://github.com/jollheef/nixos-conf /mnt/etc/nixos
    # nixos-generate-config --root /mnt # generate hardware-configuration.nix
    # sed -i "s/thiq/${NIXOS_NAME}/g" /mnt/etc/nixos/configuration.nix # change installation name
    # vim /mnt/etc/nixos/configuration.nix # you must edit some settings like a vpn/wifi support
    # mount -o remount,size=4G /nix/.rw-store # avoid space left
    # nixos-install
    # wpa_passphrase SSID PASSWORD >> /mnt/etc/wpa_supplicant.conf # optional but I usually do this
    # reboot
