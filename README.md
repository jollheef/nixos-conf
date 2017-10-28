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
    # mklabel msdos
    # mkpart primary ext4 0 100%

Encrypt it and mount

    # export NIXOS_NAME="thiq" # use you own value and do not forget to change it in configuration.nix
    # cryptsetup luksFormat /dev/sda1
    # cryptsetup luksOpen /dev/sda1  ${NIXOS_NAME}
    # mkfs.ext4 -L ${NIXOS_NAME} /dev/mapper/${NIXOS_NAME}
    # mount /dev/mapper/${NIXOS_NAME} /mnt

Installation

    # git clone https://github.com/jollheef/nixos-conf /mnt/etc/nixos
    # nixos-generate-config --root /mnt # generate hardware-configuration.nix
    # nixos-install
    # wpa_passphrase SSID PASSWORD >> /mnt/etc/wpa_supplicant.conf # optional but I usually do this
    # reboot
