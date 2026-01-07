{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

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
  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
    };
    efi.canTouchEfiVariables = true;
  };


  networking.hostName = "gram";

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
  #   LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Wayland related
  security.polkit.enable = true;

  services = {
    desktopManager.plasma6.enable = true;
    desktopManager.cosmic.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    gwenview
    khelpcenter
    konsole
    plasma-browser-integration
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  
  # Gram requirement
  programs.dconf.enable = true;

  # Enable graphics acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Touchpad
  services.libinput.touchpad.naturalScrolling = false;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      grant = {
        isNormalUser = true;
        description = "grant";
        extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    btop
    curl
    firefox
    git
    gh
    go
    ghostty
    neovim
    wget
    wl-clipboard
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

  programs.steam.enable = true;

  # Fix for specific Gram overheating
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      TLP_DEFAULT_MODE = "BAT";
      TLP_PERSISTENT_DEFAULT = 1;
    };
  };


  system.stateVersion = "23.11"; # Release version on installation, no need to change.

}
