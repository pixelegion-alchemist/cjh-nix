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
		unstable.orca-slicer
		slack
		unstable.discord
		zapzap
		krita
		filezilla
		nfs-utils
		tailscale
		github-desktop
		python310
		ffmpeg
		vlc
		inkscape
		nodejs_24
		obs-studio
		obs-studio-plugins.obs-source-record
		gimp3
		dunst
		btop
		fastfetch
		f3d
		unrar
		unzip
		docker
		docker-compose
		dropbox
		cudatoolkit
		libreoffice
		kdePackages.kdenlive
		kdePackages.kcalc
		unstable.windsurf
		unstable.zoom-us
		unstable.godot
		unstable.davinci-resolve-studio
		unstable.rclone
		unstable.blender
		uv
		audacity
		polonium
		xorg.xkill
		virt-manager
		spice-gtk
		spice-vdagent
		virglrenderer
		mesa-demos
		qemu_full
		pika-backup
  ];

  programs.git.enable = true;
}
