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
    wget vim gnupg git tmux zsh pass lxappearance sakura emacs chromium dmenu
    xlibs.xmodmap ubuntu_font_family
  ];

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us,ru";
  services.xserver.xkbOptions = "ctrl:nocaps,grp:rctrl_toggle";

  environment.etc."X11/xorg.conf.d/60-trackball.conf".text = ''
      Section "InputClass"
        Identifier  "Marble Mouse"
        MatchProduct "Logitech USB Trackball"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
        Option "ButtonMapping" "3 8 1 4 5 6 7 2 2"
        Option "EmulateWheel" "true"
        Option "EmulateWheelButton" "9"
        Option "EmulateWheelInertia" "10"
        Option "ZAxisMapping" "4 5"
        Option "Emulate3Buttons" "true"
      EndSection
    '';

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.slim = {
    enable = true;
    defaultUser = "mikhail";
    theme = "/etc/nixos/files/slim-minimal2";
  };

  # Xmonad
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;

  users.extraUsers.mikhail = {
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
