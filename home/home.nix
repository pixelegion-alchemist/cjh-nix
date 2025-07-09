{ pkgs, unstablePkgs, ... }:

{
  home.username      = "wowmonkey";
  home.homeDirectory = "/home/wowmonkey";

  home.stateVersion = "25.05";

  # Mix & match
  home.packages = with pkgs; [
    krita
    (unstablePkgs.vscode)          
  ];

  programs.git.enable = true;
}