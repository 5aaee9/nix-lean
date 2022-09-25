{ lede, buildUBoot, fetchgit }:

let
  rkbin = fetchgit {
    url = "https://github.com/rockchip-linux/rkbin.git";
    rev = "b0c100f1a260d807df450019774993c761beb79d";
    sha256 = "sha256-V7RcQj3BgB2q6Lgw5RfcPlOTZF8dbC9beZBUsTvaky0=";
  };
in
buildUBoot {
  defconfig = "r66s-rk3568_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  filesToInstall = [ "idbloader.img" "u-boot.itb" ];
  extraConfig = ''
    CONFIG_DISTRO_DEFAULTS=y
    CONFIG_BOOTDELAY=5
  '';

  postConfigure = ''
    cp ${rkbin}/bin/rk35/rk3568_ddr_1560MHz_v1.13.bin ram_init.bin
  '';

  extraPatches = [
    "${lede}/package/boot/uboot-rockchip/patches/001-rockchip-rk3568-add-boot-device-detection.patch"
    "${lede}/package/boot/uboot-rockchip/patches/002-rockchip-rk3568-enable-automatic-power-savings.patch"
    "${lede}/package/boot/uboot-rockchip/patches/003-Makefile-rockchip-HACK-build-rk3568-images.patch"
    "${lede}/package/boot/uboot-rockchip/patches/004-arm-dts-sync-rk3568-with-linux.patch"
    "${lede}/package/boot/uboot-rockchip/patches/005-rockchip-rk356x-HACK-fix-sdmmc-support.patch"
    "${lede}/package/boot/uboot-rockchip/patches/006-rockchip-rk356x-add-quartz64-a-board.patch"
    "${lede}/package/boot/uboot-rockchip/patches/007-gpio-rockchip-rk_gpio-support-v2-gpio-controller.patch"
    "${lede}/package/boot/uboot-rockchip/patches/008-rockchip-allow-sdmmc-at-full-speed.patch"
    "${lede}/package/boot/uboot-rockchip/patches/009-rockchip-defconfig-add-gpio-v2-to-quartz64.patch"
    "${lede}/package/boot/uboot-rockchip/patches/010-rockchip-rk356x-enable-usb2-support-on-quartz64-a.patch"
    "${lede}/package/boot/uboot-rockchip/patches/011-rockchip-rk356x-attempt-to-fix-ram-detection.patch"
    "${lede}/package/boot/uboot-rockchip/patches/012-resync-rk3566-device-tree-with-mainline.patch"
    "${lede}/package/boot/uboot-rockchip/patches/013-rockchip-rk356x-add-bpi-r2-pro-board.patch"
    "${lede}/package/boot/uboot-rockchip/patches/014-uboot-add-Radxa-ROCK-3A-board.patch"
    "${lede}/package/boot/uboot-rockchip/patches/015-uboot-add-NanoPi-R5S-board.patch"
    "${lede}/package/boot/uboot-rockchip/patches/100-Convert-CONFIG_USB_OHCI_NEW-et-al-to-Kconfig.patch"
    "${lede}/package/boot/uboot-rockchip/patches/104-mkimage-add-public-key-for-image.patch"
    "${lede}/package/boot/uboot-rockchip/patches/105-Only-build-dtc-if-needed.patch"
    "${lede}/package/boot/uboot-rockchip/patches/106-no-kwbimage.patch"
    "${lede}/package/boot/uboot-rockchip/patches/203-rock64pro-disable-CONFIG_USE_PREBOOT.patch"
    "${lede}/package/boot/uboot-rockchip/patches/301-arm64-dts-rockchip-Add-GuangMiao-G4C-support.patch"
    "${lede}/package/boot/uboot-rockchip/patches/302-rockchip-rk3328-Add-support-for-Orangepi-R1-Plus.patch"
    "${lede}/package/boot/uboot-rockchip/patches/303-rockchip-rk3328-Add-support-for-Orangepi-R1-Plus-LTS.patch"
    "${lede}/package/boot/uboot-rockchip/patches/304-rockchip-rk3328-Add-support-for-FriendlyARM-NanoPi-R.patch"
    "${lede}/package/boot/uboot-rockchip/patches/305-rockchip-rk3399-Add-support-for-FriendlyARM-NanoPi-R.patch"
    "${lede}/package/boot/uboot-rockchip/patches/311-rockchip-rk3568-Add-support-for-ezpro_mrkaio-m68s.patch"
    "${lede}/package/boot/uboot-rockchip/patches/312-rockchip-rk3568-Add-support-for-hinlink-opc-h68k.patch"
    "${lede}/package/boot/uboot-rockchip/patches/313-rockchip-rk3568-Add-support-for-fastrhino-r66s.patch"
    "${lede}/package/boot/uboot-rockchip/patches/314-rockchip-rk3568-Add-support-for-Station-P2.patch"
  ];
}
