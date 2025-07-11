{ pkgs, ... }:

{
  home.username      = "wowmonkey";

  home.stateVersion = "25.05";
	home.sessionVariables = {
		STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
	};		
	


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
	gimp3
	btop
	docker
    unstable.windsurf
    unstable.zoom-us
    unstable.godot
    unstable.davinci-resolve-studio
  ];

  programs.git.enable = true;
}
