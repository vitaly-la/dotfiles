{ config, ... }:
{
  system.stateVersion = "24.05";

  imports = [ /etc/nixos/hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
    blacklistedKernelModules = [ "uvcvideo" "rtw88_8821ce" ];
    extraModulePackages = [ config.boot.kernelPackages.rtl8821ce ];
    kernel.sysctl."kernel.sysrq" = 1;
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 10 * 1024;
  }];

  networking = {
    hostName = "pc117";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/London";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  fileSystems = {
    "/boot".options = [ "noatime" ];
    "/".options = [ "noatime" ];
  };
  services.fstrim.enable = true;
}
