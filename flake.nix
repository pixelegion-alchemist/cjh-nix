{
  description = "NixOS 25.05 base + unstable overlay + Home Manager";

  inputs = {
    # 1) stable system channel (25.05)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # 2) latest unstable for extra packages
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # 3) Home-Manager that tracks 25.05
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, unstable, home-manager, ... }:
  let
    system = "x86_64-linux";

    # ― stable pkgs (allow unfree once, here) ──────────────────────────────
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

    # ― full unstable set, also unfree ─────────────────────────────────────
    unstablePkgs = import unstable { inherit system; config.allowUnfree = true; };
  in
  {
    nixosConfigurations.nixylearn = nixpkgs.lib.nixosSystem {
      inherit system;

      # -------- NixOS module list ----------------------------------------
      modules = [
        ./machines/nixylearn/configuration.nix
        ./machines/nixylearn/hardware-configuration.nix

        # Home-Manager as an OS module
        home-manager.nixosModules.home-manager

        # Inline tweaks (adds user + passes pkgs to HM)
        {
          # no second allowUnfree / overlays definitions here!
          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true;

          home-manager.users.wowmonkey =
            import ./home/home.nix { inherit pkgs unstablePkgs; };
        }
      ];

      # Extra arguments every module can access
      specialArgs = {
        inherit pkgs unstablePkgs inputs;
      };
    };
  };
}
