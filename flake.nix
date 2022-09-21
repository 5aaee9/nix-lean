{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    lede = {
      url = "github:coolsnowwolf/lede";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, lede }: let
    systemPackage = system: import nixpkgs { inherit system; };
    crossPackage = system: import nixpkgs {
      inherit system;
      crossSystem.config = "aarch64-unknown-linux-gnu";
    };
  in
  {
    packages.x86_64-linux = import ./packages { pkgs = crossPackage "x86_64-linux"; inherit lede; };
    packages.aarch64-linux = import ./packages { pkgs = systemPackage "aarch64-linux"; };
  };
}
