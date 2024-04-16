{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
  
  hardware.opengl.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.auto-optimise-store = true;
  
  # Garbage collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 60d";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-88c5f3f3-fa18-444b-9f14-67783e7a37ab".device = "/dev/disk/by-uuid/88c5f3f3-fa18-444b-9f14-67783e7a37ab";

  networking.hostName = "surface";

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
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
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

    NIXOS_CONFIG_PROFILE = "surface";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];
  };

  system.stateVersion = "23.11"; # No need to change

}
