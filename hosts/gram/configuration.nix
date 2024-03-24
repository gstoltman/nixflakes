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
 
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-7a6506cd-e9e6-4d21-bb2e-90a25c527df8".device = "/dev/disk/by-uuid/7a6506cd-e9e6-4d21-bb2e-90a25c527df8";
  
  networking.hostName = "gram"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    desktopManager = {
      plasma5.enable = true;
    };
    displayManager = {
      sddm.enable = true;
    };
    windowManager = {
      #i3 = {
      #  enable = true;
      #  package = pkgs.i3-gaps;
      #};
    };
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
