{
  description = "SonicWall NetExtender for NixOS";

 inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Use the correct Nixpkgs version

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.netextender = import ./default.nix { pkgs = nixpkgs.legacyPackages.x86_64-linux; };

    nixosModules.netextender = import ./module.nix;
  };
}

