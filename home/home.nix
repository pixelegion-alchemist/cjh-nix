{ pkgs, ... }:

{
  home.username      = "wowmonkey";

#   home.stateVersion = "25.05";



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
	blender
	inkscape
	nodejs_24
	obs-studio
	rclone
	git
	brave
    unstable.windsurf
    unstable.zoom-us
    unstable.godot
  ];

  programs.git.enable = true;
}
