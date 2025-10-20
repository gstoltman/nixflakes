{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      # Currently exclusive for handling Switch Gamepad
      ../imports/default.nix
    ];

  nixpkgs.overlays = [ (import ../../overlays/default.nix) ];
  
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

  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "void";

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
  
  # Wayland related
  security.polkit.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
        --time \
        --asterisks \
        --user-menu \
        --cmd sway
      '';
    };
  };
  environment.etc."greetd/environments".text = ''
    sway
  '';

  # Enable graphics acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

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
        extraGroups = [ "docker" "libvirtd" "networkmanager" "wheel" ];
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

  # VM Setup
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["grant"];
  virtualisation = {
    docker = {
      enable = true;
      daemon.settings.experimental = true;
    };
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  environment.sessionVariables = rec {
    EDITOR = "nvim";

    NIXOS_CONFIG_PROFILE = "void";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];
  };

  # Steam
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "-W" "3440"
        "-H" "1440"
        "-r" "144"
      ];
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  system.stateVersion = "23.11"; # Release version on installation, no need to change.

}
