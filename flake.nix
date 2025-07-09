{
  description = "Colin's nix.conf under source control";

  outputs = { self, nixpkgs }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    packages.x86_64-linux = rec {
      # Install /etc/nix/nix.conf (needs sudo each time you run it)
      installSystemNixConf = pkgs.writeShellScriptBin "install-system-nixconf" ''
        set -eu
        sudo install -Dm644 "${self + /nix/nix.conf}" /etc/nix/nix.conf
        echo "✓ /etc/nix/nix.conf updated from flake"
      '';

      # Install ~/.config/nix/nix.conf (no sudo)
      installUserNixConf = pkgs.writeShellScriptBin "install-user-nixconf" ''
        set -eu
        install -Dm644 "${self + /home/nix.conf}" "$HOME/.config/nix/nix.conf"
        echo "✓ ~/.config/nix/nix.conf updated from flake"
      '';
    };
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.installSystemNixConf;
  };
}
