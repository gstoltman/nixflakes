# home-manager switch --flake .#grant@gram
{ config, pkgs, inputs, lib, ... }:

{
  home.username = "grant";
  home.homeDirectory = "/home/grant";
  home.stateVersion = "24.05";
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  imports = [
    ./alacritty.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    bat
    fzf
    neofetch
    ripgrep
    jq
    tree
    (nerdfonts.override { 
      fonts = ["Iosevka"];
    })
  ];
  
  home.sessionVariables = {
    EDITOR="nvim";
  };

  xdg.configFile."qtile/config.py".source = ../dotfiles/qtile/config.py; 

}
