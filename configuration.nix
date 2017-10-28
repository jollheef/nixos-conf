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

  networking.hostName = "thiq"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget vim gnupg git tmux zsh pass
  ];

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  #services.xserver.layout = "us,ru";
  #services.xserver.xkbOptions = "ctrl:nocaps";

  # Enable touchpad support.
  #services.xserver.libinput.enable = true;

  #services.xserver.windowManager.xmonad.enable = true;
  #services.xserver.windowManager.xmonad.enableContribAndExtras = true;

  users.extraUsers.guest = {
    isNormalUser = true;
    home = "/home/mikhail";
    extraGroups = ["wheel" "audio" "plugdev"];
    createHome = true;
    shell = "/run/current-system/sw/bin/zsh";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
