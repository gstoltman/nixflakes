{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.opengl.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.auto-optimise-store = true;

  # Garbage Collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 60d";
  };
 
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "gram"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
#    desktopManager = {
#      plasma5.enable = true;
#    };
    displayManager = {
      lightdm.enable = true;
    };
    windowManager = {
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };
    # Touchpad
#    libinput = {
#      enable = true;
#      touchpad.naturalScrolling = true;
#    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.grant = {
    isNormalUser = true;
    description = "grant";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
# List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    alacritty
    btop
    curl
    firefox
    git
    home-manager
    neovim
    wget
    xclip
  ];
  
  environment.sessionVariables = rec {
    EDITOR = "nvim";

    NIXOS_CONFIG_PROFILE = "gram";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];
  };

  # Fix for CPU Overheat on Gram
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["intel_pstate=disable"];
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    extraConfig = ''
      START_CHARGE_THRESH_BAT0=75
      STOP_CHARGE_THRESH_BAT0=95
      CPU_SCALING_GOVERNOR_ON_AC=schedutil
      CPU_SCALING_GOVERNOR_ON_BAT=schedutil
      CPU_SCALING_MIN_FREQ_ON_AC=400000
      CPU_SCALING_MAX_FREQ_ON_AC=3500000
      CPU_SCALING_MIN_FREQ_ON_BAT=400000
      CPU_SCALING_MAX_FREQ_ON_BAT=2300000
      # Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
      # Default: on (AC), auto (BAT)
      RUNTIME_PM_ON_AC=on
      RUNTIME_PM_ON_BAT=auto
      # Battery feature drivers: 0=disable, 1=enable
      # Default: 1 (all)
      NATACPI_ENABLE=1
      TPACPI_ENABLE=1
      TPSMAPI_ENABLE=1
    '';
  };

  system.stateVersion = "23.11"; # Release version on installation, no need to change.

}
