{ pkgs, unstablePkgs, ... }:

{
  home.username      = "wowmonkey";
  home.homeDirectory = "/home/wowmonkey";

  home.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;

  # Mix & match
  home.packages = with pkgs; [
    wget
	obsidian
	orca-slicer
	slack
	discord
	zapzap
	krita
	filezilla
	tailscale
	github-desktop
	python310
	ffmpeg
	vlc
	zoom-us
	inkscape
	nodejs_24
	obs-studio
	rclone
	git
    (unstablePkgs.windsurf)
  ];

  programs.git.enable = true;
}
