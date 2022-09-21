{ pkgs, lede }:

with pkgs;

{
  linux_rockchip-5_19 = callPackage ./rockchip-5.19.nix { inherit lede; };

  uboot_r66s = callPackage ./uboot-r66s.nix { inherit lede; };
}
