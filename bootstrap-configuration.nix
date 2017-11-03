# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."thiq".allowDiscards = true;
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  swapDevices = [
    { device = "/var/swapfile";
      size = 4096; # MiB
    }
  ];

  environment.systemPackages = with pkgs; [                    
    vim git 
  ];

  networking.hostName = "thiq"; # Define your hostname.

  system.stateVersion = "17.09";
}
