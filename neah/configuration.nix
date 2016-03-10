# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./guixbuilder.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/disk/by-id/ata-SB_M2_SSD_FF73075C0E0803303023";
  boot.extraKernelParams = [ "i915.enable_ips=0" "tpm_tis.interrupts=0" ];
  boot.extraModprobeConfig =
    ''
     options snd-hda-intel model=,alc283-dac-wcaps
     options iwlwifi swcrypto=1
     options snd slots=snd-hda-intel
    '';
  boot.kernel.sysctl."vm.swappiness" = 10;
  boot.kernel.sysctl."vm.dirty_background_bytes" = 0;
  boot.kernel.sysctl."vm.dirty_bytes" = 0;
  boot.kernel.sysctl."vm.dirty_ratio" = 20;
  boot.kernel.sysctl."vm.dirty_background_ration" = 10;
  boot.kernel.sysctl."vm.dirty_writeback_centisecs" = 500;
  boot.kernel.sysctl."fs.aio-max-nr" = 8192;

  hardware.pulseaudio.enable = true;
  networking.hostName = "neah"; # Define your hostname.
  networking.networkmanager.enable = true;
  # Select internationalisation properties.
  i18n = {
     consoleKeyMap = "dvorak";
     defaultLocale = "en_US.UTF-8";
   };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
     wget
     vim
  ];

  # List services that you want to enable:

  services.xserver.layout = "dvorak";
  services.xserver.enable = true;
  services.xserver.synaptics.enable = true;
  #services.xserver.windowManager = { name = "" ; };
  services.xserver.desktopManager.xterm.enable = false;
  #services.xserver.windowManager.notion.enable = true;
#  services.xserver.desktopManager.session.default = [];
  services.xserver.autorun = false;

  services.guixdaemon.enable = true;

  services.openssh.enable = true;
  services.openssh.ports = [ 4096 ];

  services.avahi.enable = true;
  services.avahi.ipv4 = true;
  services.avahi.ipv6 = true;
  services.avahi.nssmdns = true; 
  services.avahi.interfaces = [ "wlp1s0" ];

  networking.interfaces."tinc.codebase".ip6 = [
    { address = "fd00:c0de:ba5e::105"; prefixLength = 64; }
  ];
  networking.networkmanager.unmanaged = [ "interface-name:tinc.codebase" ];
  services.tinc.networks = {
    codebase = {
      extraConfig = ''
        ConnectTo = codebase
      '';
      listenAddress = "fd00:c0de:ba5e::105";
      hosts = {
        codebase = ''
          Address = 54.68.71.163
          Subnet = fd00:c0de:ba5e::1/128
          
          -----BEGIN RSA PUBLIC KEY-----
          MIICCgKCAgEA0/eR7ZPhR9ExtszeqRv0w9luYfIJ45GvD+S8NUZWG2Z7zCc8H5af
          AuNEnB+JqC3uUZKQsGw1MbYfkL3Rdkrs+LJ00JyetT3MFq/Q7gWbnLfJjdtSHgMG
          v/cZ5djdMYqAqrfKEVSxS9Z2r8Sh9RduW/zxpBN9LtektUG/L1MGlI1qpcwCVaY7
          FhEB+d9QwiddAL53/hlK9oZzAsh0MWQii2/tj6u67aPL5uw30b0WNZx+8u2MURQG
          gkdwvL1Am+R78etsd+0QfDjuy+LH3iwCIdFeup6z/LUdrBe70hNFFq6PZ345FgQH
          yEdo894Jf8NUcyZHOU5MOmHOURBAgGkO/nNLdlgr0ciAfJSRnjVIeOo05URMyOyh
          312xT00ysYFRxJOAn5MnF4VHYga2aa/M3dq11i0iYB4RBHmuPXI1XI9T/VnQ/90J
          zPlcgIqYR/rVFKcqZ8uwoX+0nIHplqI7MEroOrp/nDL7iE32pEa19749oEnXDl2+
          +UsNp6qDogOYVZ4Lro+zSah6hIhHoY7WfJ6p9DMntVOthZIGILkzSrBBZe4E87b3
          YNi092mOhDjFGNGdGE+i/Alhf0Ooio+EZ+C0XwgsLg3v6hfO9XSBlKlHqskrjpoZ
          9K4KCYXhRIfy6hL7g9VnbY/vvdiL2iD89f9DAYPV1D/WcOpr26pYOAkCAwEAAQ==
          -----END RSA PUBLIC KEY-----
        '';  
        neah = ''
          Subnet = fd00:c0de:ba5e::105/128
          Ed25519PublicKey = OYfNUU6t520fKi04YTZIrXS8wJdqFVOLOoMwQkuuiyA
          -----BEGIN RSA PUBLIC KEY-----
          MIICCgKCAgEA7XPJknNemMSnXnIDzWRECVL/NBmSjImCMvDECEMkjZ4buUoOs2ct
          CXJIfS9BIFx453+YLgEfc1OVdZPnCOvMROyzJGcGMuzJ+uSf8bPu3Jy3PktpEPxl
          SyGvlJqjIpf/7BzVskhOPgXG8UPmgImU48ll7PgK0M1wv5LrQkTrVUW0iGzuYm8W
          I0L9UgNkZh9phLFbu5drzOQztQ3mqOoDu9DF2W88kHWw9vBnFY29tpFHNFRAnBlq
          wuFiP3Q1GIv6olmflKYzi6CfPDjpInnjgRqdcEML5vIJ3e3t2JIseg2FB2jk+est
          ULR1HNs8FKHh3hobDRFNGw+MJpeaSl/Yr9EPM07TQmLtFcG//5QdzEEPAlWfBEP7
          /p0wzg3FBW+Wk3/AfUMRpHPbD6a544POGLNmxCoIdKGlZHbrDuiN46faoj5GIZaZ
          cCnerJqhAFySRufHkHTwbr17ucuw5Pa44sSa585ECh8kCI3GzkFbe8j6jYHVkrNW
          fccSkVjMX/HbUEgMCXzegr58f5g8QgGG72W68YtrfcA2n8Rmh5ipuavfmIA2Gh4x
          hZZeVDiBYcmUlh1nYkFDeO+b+LBixZpyEy+dsMxCPefryQYJrNqs3H9yhEyOkmXS
          ZdoLHwMX9+3aPTnK47lTIsfXH3B51mbwic0nEv+N99soFCqlQA/Hx28CAwEAAQ==
          -----END RSA PUBLIC KEY-----
        '';                    
      };
    };
  };
      
    


  users.extraUsers.guest = {
    isNormalUser = true;
    name = "codemac";
    home = "/home/codemac";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    createHome = true;
    useDefaultShell = true;   
    uid = 1000;
  };

  nix.useChroot = true;
  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
