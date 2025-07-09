{
### 0. Metadata — totally optional
  description = "Colin's nix.conf under source control";

### 1. Inputs (what this flake depends on)
 inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixos-25.05";   # or nixos-unstable
    unstable.url     = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url  = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
   };

### 2. Outputs (what this flake provides)
  outputs = { self, nixpkgs, unstable, home-manager }: let
    pkgsStable = nixpkgs.legacyPackages.x86_64-linux;
    pkgsUnstable = unstable.legacyPackages.x86_64-linux;
    username = "wowmonkey";

  in {
    packages.x86_64-linux = rec {

      installSystemNixConf = pkgsStable.writeShellScriptBin "install-system-nixconf" ''
        set -eu
        sudo install -Dm644 "${self + /nix/nix.conf}" /etc/nix/nix.conf
        echo "✓ /etc/nix/nix.conf updated from flake"
      '';

      installUserNixConf = pkgsStable.writeShellScriptBin "install-user-nixconf" ''
        set -eu
        install -Dm644 "${self + /home/nix.conf}" "$HOME/.config/nix/nix.conf"
        echo "✓ ~/.config/nix/nix.conf updated from flake"
      '';

      default = installUserNixConf;
    };

    homeConfigurations.${username} =
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsStable;                    

        extraSpecialArgs = {                   
          unstablePkgs = pkgsUnstable;
        };
        modules = [ ./home/home.nix ];
      };

    
  };
}
