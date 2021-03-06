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
    # utils
    wget tmux zsh vim emacs htop acpi bc p7zip mpv
    gnupg pinentry git pass unzip w3m whois dnsutils feh
    parted iotop nmap tldr sshfs
    # dev
    go gnumake gcc clang clang-analyzer global
    python2Full python3Full python27Packages.ipython python36Packages.ipython
    # base x
    dmenu xlibs.xmodmap ubuntu_font_family i3lock lxappearance sakura
    xfce.xfce4notifyd libnotify gtk_engines xorg.xbacklight x2x
    # x apps
    chromium thunderbird tdesktop scrot gimp
    google-play-music-desktop-player
    zathura wireshark transmission_gtk
    fswebcam
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

  services.openssh = {
    enable = true;
    forwardX11 = true;
    passwordAuthentication = false;
  };

  # Screen locking on lid close
  services.acpid = {
    enable = true;
    lidEventCommands = ''
      if grep -q closed /proc/acpi/button/lid/*/state; then
        DISPLAY=":0.0" XAUTHORITY=/home/mikhail/.Xauthority ${pkgs.i3lock}/bin/i3lock -n -c 000000 &
      fi
      if grep -q open /proc/acpi/button/lid/*/state; then
        /run/current-system/sw/bin/systemctl restart openvpn-primary &
      fi
    '';
  };

  # vpn
  services.openvpn.servers = {
    primary = { config = '' config /home/mikhail/etc/vpn/client/primary.ovpn ''; };
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

  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
