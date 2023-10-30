{ pkgs, home-manager, username, ... }:
{
  imports = [ 
    ./browsing
    ./vscode
  ];
  home-manager.users.${username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      obsidian
      discord
     ];
  };
}
