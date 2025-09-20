# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  fileSystems."/mnt/podsync" = {
    device = "192.168.0.11:/mnt/instances/podsync";
    fsType = "nfs";
  };

  fileSystems."/mnt/prod" = {
    device = "192.168.0.11:/mnt/instances/prod";
    fsType = "nfs";
  };

  fileSystems."/mnt/colin_abstract" = {
    device = "192.168.0.11:/mnt/big18/colin_abstract";
    fsType = "nfs";
  };

  fileSystems."/mnt/zdrive" = {
    device = "192.168.0.11:/mnt/big18/zdrive";
    fsType = "nfs";
  };


  boot.supportedFilesystems = [ "nfs" ];

#   boot.kernelPackages = pkgs.linuxPackages_6_12_hardened;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  boot.kernelModules = [ "v4l2loopback" ];
  security.polkit.enable = true;

  networking.hostName = "bloodynix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];

  #allow things like UV to work
  programs.nix-ld.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  services.tailscale.enable = true;
  services.hardware.openrgb.enable = true;
  hardware.bluetooth.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.groups.wowmonkey = {
    name = "wowmonkey";
    gid = 3001;
    members = [ "wowmonkey" ];
  };
    users.groups.pixelegion = {
    name = "pixelegion";
    gid = 3002;
    members = [ "wowmonkey" ];
  };
    users.groups.hodges = {
    name = "hodges";
    gid = 3003;
    members = [ "wowmonkey" ];
  };
    users.groups.greencgmonkey = {
    name = "greencgmonkey";
    gid = 3004;
    members = [ "wowmonkey" ];
  };

  users.users.wowmonkey = {
    isNormalUser = true;
    description = "wowmonkey";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Key App Configs
  programs.firefox.enable = true;  # firefox
  programs.steam.enable = true;  # steam
  programs.steam.gamescopeSession.enable = true;  # steam gamescope
  programs.steam.remotePlay.openFirewall = true;  # steam remote play
  programs.gamemode.enable = true;  # gamemode
  virtualisation.docker.enable = true;  # docker
  hardware.nvidia-container-toolkit.enable = true; 
  programs.ssh.startAgent = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   brave
   git
   git-lfs
   protonup
  #  wget
  ];

  services.flatpak.enable = true;
  services.flatpak.packages = [
    { appId = "app.zen_browser.zen"; origin = "flathub"; }
  ];

  home-manager = {
	extraSpecialArgs = {inherit inputs; };
	users = {
		"wowmonkey" = import ../../home/home.nix;
	};
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  powerManagement.cpuFreqGovernor = "ondemand";

}
