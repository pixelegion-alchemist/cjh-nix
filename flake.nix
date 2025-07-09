{
### 0. Metadata — totally optional
  description = "Colin's nix.conf under source control";

### 1. Inputs (what this flake depends on)
 inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixos-25.05";   # or nixos-unstable
    home-manager.url  = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
   };

### 2. Outputs (what this flake provides)
  outputs = { self, nixpkgs, home-manager }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    username = builtins.getEnv "USER";   # returns "" if USER isn’t set
  in {
    packages.x86_64-linux = rec {

      installSystemNixConf = pkgs.writeShellScriptBin "install-system-nixconf" ''
        set -eu
        sudo install -Dm644 "${self + /nix/nix.conf}" /etc/nix/nix.conf
        echo "✓ /etc/nix/nix.conf updated from flake"
      '';


      installUserNixConf = pkgs.writeShellScriptBin "install-user-nixconf" ''
        set -eu
        install -Dm644 "${self + /home/nix.conf}" "$HOME/.config/nix/nix.conf"
        echo "✓ ~/.config/nix/nix.conf updated from flake"
      '';
    };

    homeConfigurations.${username} =
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/home.nix ];
      };

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.installSystemNixConf;
  };
}
