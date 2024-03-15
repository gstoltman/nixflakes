<div align="center">
  <a href="https://github.com/gstoltman/nixflakes">
    <img src="assets/nix-snowflake.svg" alt="Logo" width="80" height="80">
  </a>

  <h1 align="center">System Configuration with NixOS</h1>
</div>

### Installation

Official installation instructions can be found in the 
[NixOS Wiki](https://nixos.wiki/wiki/NixOS_Installation_Guide).

I deploy my Nixos configuration as a flake which needs be enabled
via the option```nix.settings.experimental-features = [ "nix-command" "flakes" ];```.
Typically this requires manually adding it to the preexisting config
found at `/etc/nixos/configuration.nix` and then rebuilding with
```sudo nixos-rebuild switch --flake /path/to/flake/#flake_profile```

[Nix Flakes documentation](https://nixos.wiki/wiki/Flakes) if
needed.

### Rebuilding and Updating
To rebuild nixos, run the command 
```sudo nixos-rebuild switch --flake /path/to/flake/#flake_profile```
where `flake_profile` is whatever gets set in your flake.nix.  

One advantage of nixos as a flake is pinned dependencies for reproducibility (flake.lock).
In practice, this means the nix channel I follow gets pinned and
thus all packages I download and install are the same across
all machines I use. To upgrade all system packages, I run the
command ```nix flake update```, rebuild nixos, and then 
commit my new lockfile.
