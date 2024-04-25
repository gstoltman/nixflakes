self: super:

with { callPackage = super.callPackage; };

{
  steamcontroller-udev-rules = callPackage ../pkgs/steamcontroller-udev-rules { };
}
