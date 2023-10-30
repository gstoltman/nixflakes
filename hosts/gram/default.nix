{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  #----Host specific config ----
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["intel_pstate=disable"];
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    extraConfig = ''
      START_CHARGE_THRESH_BAT0=75
      STOP_CHARGE_THRESH_BAT0=80

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
}


