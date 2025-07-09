{ pkgs, unstablePkgs, ... }:

{
  home.username      = "wowmonkey";
  home.homeDirectory = "/home/wowmonkey";

  # Mix & match
  home.packages = with pkgs; [
    krita
    (unstablePkgs.vscode)          
  ];

  programs.git.enable = true;
}