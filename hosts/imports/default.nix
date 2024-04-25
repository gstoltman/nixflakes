{ config, pkgs, lib, ... }:

{
  services.udev.packages = [ pkgs.steamcontroller-udev-rules ];
}
