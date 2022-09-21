{ lede, fetchurl, buildLinux, lib, runCommand, rsync, ... } @ args:

let
  kernel = fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.19.6.tar.xz";
    sha256 = "sha256-QaT4JK9hRGDEKafHI+jcuw4ELwBH0yjBi07W8rTvpjo=";
  };

  kernelWithFiles = runCommand "kernel-5.19.6-with-rockchip-files" {
    nativeBuildInputs = [ rsync ];
  } ''
    mkdir $out
    tar -xJf ${kernel} --strip-components=1 -C $out
    rsync -auIv ${lede}/target/linux/rockchip/files/ $out
    rsync -auIv ${lede}/target/linux/rockchip/files-5.19/ $out

  '';
in
buildLinux (args // rec {
  version = "5.19.6";
  modDirVersion = version;

  src = kernelWithFiles;
  structuredExtraConfig = with lib.kernel; {
    CONFIG_DRM_LOAD_EDID_FIRMWARE = yes;
    CONFIG_DRM_FBDEV_EMULATION = yes;
    CONFIG_DRM_FBDEV_OVERALLOC = freeform "100";
    CONFIG_HDMI = yes;
    CONFIG_DRM = yes;
    CONFIG_DRM_BRIDGE = yes;
    CONFIG_DRM_DEBUG_MODESET_LOCK  = yes;
    CONFIG_DRM_DISPLAY_HDMI_HELPER  = yes;
    CONFIG_DRM_DISPLAY_HELPER  = yes;
    CONFIG_DRM_DW_HDMI = yes;
    CONFIG_DRM_DW_MIPI_DSI  = yes;
    CONFIG_DRM_GEM_CMA_HELPER  = yes;
    CONFIG_DRM_KMS_HELPER  = yes;
    CONFIG_DRM_MIPI_DSI  = yes;
    CONFIG_DRM_NOMODESET  = yes;
    CONFIG_DRM_PANEL = yes;
    CONFIG_DRM_PANEL_BRIDGE  = yes;
    CONFIG_DRM_PANEL_ORIENTATION_QUIRKS  = yes;
    CONFIG_DRM_ROCKCHIP  = yes;

    CONFIG_PHY_ROCKCHIP_INNO_HDMI = module;
    CONFIG_DRM_DW_HDMI_CEC = module;
    CONFIG_ROCKCHIP_ANALOGIX_DP = no;
    CONFIG_ROCKCHIP_CDN_DP = no;
    CONFIG_ROCKCHIP_DW_HDMI = yes;
    CONFIG_ROCKCHIP_INNO_HDMI = yes;
    CONFIG_ROCKCHIP_DW_MIPI_DSI = yes;
    CONFIG_ROCKCHIP_LVDS = yes;
    CONFIG_ROCKCHIP_RGB = no;
    CONFIG_ROCKCHIP_RK3066_HDMI = no;
    CONFIG_DRM_PANEL_SIMPLE = module;

    CONFIG_DRM_MGAG200 = no;
  };
  kernelPatches = [
    {
      name = "0000-arm64-dts-rockchip-add-EEPROM-node-for-NanoPi-R4S";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0000-arm64-dts-rockchip-add-EEPROM-node-for-NanoPi-R4S.patch";
    }
    {
      name = "0001-arm64-dts-rockchip-add-Quartz64-A-fan-pinctrl";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0001-arm64-dts-rockchip-add-Quartz64-A-fan-pinctrl.patch";
    }
    {
      name = "0002-arm64-dts-rockchip-enable-sdr-104-for-sdmmc-on-Quart";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0002-arm64-dts-rockchip-enable-sdr-104-for-sdmmc-on-Quart.patch";
    }
    {
      name = "0003-arm64-dts-rockchip-enable-sfc-controller-on-Quartz64";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0003-arm64-dts-rockchip-enable-sfc-controller-on-Quartz64.patch";
    }
    {
      name = "0004-arm64-dts-rockchip-Add-rk3568-PCIe2x1-controller";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0004-arm64-dts-rockchip-Add-rk3568-PCIe2x1-controller.patch";
    }
    {
      name = "0005-arm64-dts-rockchip-Enable-PCIe-controller-on-quartz6";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0005-arm64-dts-rockchip-Enable-PCIe-controller-on-quartz6.patch";
    }
    {
      name = "0006-arm64-dts-rockchip-add-pine64-touch-panel-display-to";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0006-arm64-dts-rockchip-add-pine64-touch-panel-display-to.patch";
    }
    {
      name = "0007-arm64-dts-rockchip-rk356x-Add-VOP2-nodes";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0007-arm64-dts-rockchip-rk356x-Add-VOP2-nodes.patch";
    }
    {
      name = "0008-arm64-dts-rockchip-rk356x-Add-HDMI-nodes";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0008-arm64-dts-rockchip-rk356x-Add-HDMI-nodes.patch";
    }
    {
      name = "0009-arm64-dts-rockchip-rk3568-evb-Enable-VOP2-and-hdmi";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0009-arm64-dts-rockchip-rk3568-evb-Enable-VOP2-and-hdmi.patch";
    }
    {
      name = "0010-arm64-dts-rockchip-enable-vop2-and-hdmi-tx-on-quartz";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0010-arm64-dts-rockchip-enable-vop2-and-hdmi-tx-on-quartz.patch";
    }
    {
      name = "0013-arm64-dts-rockchip-adjust-whitespace-around";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0013-arm64-dts-rockchip-adjust-whitespace-around.patch";
    }
    {
      name = "0014-arm64-dts-rockchip-Add-HDMI-audio-nodes-to-rk356x";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0014-arm64-dts-rockchip-Add-HDMI-audio-nodes-to-rk356x.patch";
    }
    {
      name = "0015-arm64-dts-rockchip-Enable-HDMI-audio-on-Quartz64-A";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0015-arm64-dts-rockchip-Enable-HDMI-audio-on-Quartz64-A.patch";
    }
    {
      name = "0017-arm64-dts-rockchip-add-RTC-to-BPI-R2-Pro";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0017-arm64-dts-rockchip-add-RTC-to-BPI-R2-Pro.patch";
    }
    {
      name = "0019-arm64-dts-rockchip-set-display-regulators-to-always-";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0019-arm64-dts-rockchip-set-display-regulators-to-always-.patch";
    }
    {
      name = "0020-arm64-dts-rockchip-enable-vop2-and-hdmi-tx-on-BPI-R2";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0020-arm64-dts-rockchip-enable-vop2-and-hdmi-tx-on-BPI-R2.patch";
    }
    {
      name = "0021-arm64-dts-rockchip-Enable-HDMI-audio-on-BPI-R2-Pro";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0021-arm64-dts-rockchip-Enable-HDMI-audio-on-BPI-R2-Pro.patch";
    }
    {
      name = "0022-arm64-dts-rockchip-configure-thermal-shutdown-for-BP";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0022-arm64-dts-rockchip-configure-thermal-shutdown-for-BP.patch";
    }
    {
      name = "0023-arm64-dts-rockchip-enable-the-gpu-on-BPI-R2-Pro";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0023-arm64-dts-rockchip-enable-the-gpu-on-BPI-R2-Pro.patch";
    }
    {
      name = "0024-arm64-dts-rockchip-Add-missing-space-around-regulato";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0024-arm64-dts-rockchip-Add-missing-space-around-regulato.patch";
    }
    {
      name = "0025-arm64-dts-rockchip-add-ROCK-Pi-S-DTS-support";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0025-arm64-dts-rockchip-add-ROCK-Pi-S-DTS-support.patch";
    }
    {
      name = "0026-arm64-dts-rockchip-rock-pi-s-add-more-peripherals";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0026-arm64-dts-rockchip-rock-pi-s-add-more-peripherals.patch";
    }
    {
      name = "0027-arm64-dts-rockchip-align-gpio-key-node-names-with-dt";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0027-arm64-dts-rockchip-align-gpio-key-node-names-with-dt.patch";
    }
    {
      name = "0028-arm64-dts-rockchip-enable-hdmi-tx-audio-on-rk3568-ev";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0028-arm64-dts-rockchip-enable-hdmi-tx-audio-on-rk3568-ev.patch";
    }
    # {
    #   name = "0029-arm64-dts-rockchip-enable-hdmi-tx-audio-on-rock-3a";
    #   patch = "${lede}/target/linux/rockchip/patches-5.19/0029-arm64-dts-rockchip-enable-hdmi-tx-audio-on-rock-3a.patch";
    # }
    {
      name = "0030-arm64-dts-rockchip-Add-mt7531-dsa-node-to-BPI-R2-Pro";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0030-arm64-dts-rockchip-Add-mt7531-dsa-node-to-BPI-R2-Pro.patch";
    }
    {
      name = "0031-net-dsa-mt7530-rework-mt7530_hw_vlan_-add-del";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0031-net-dsa-mt7530-rework-mt7530_hw_vlan_-add-del.patch";
    }
    {
      name = "0032-net-dsa-mt7530-rework-mt753-01-_setup";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0032-net-dsa-mt7530-rework-mt753-01-_setup.patch";
    }
    {
      name = "0033-net-dsa-mt7530-get-cpu-port-via-dp-cpu_dp-instead-of";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0033-net-dsa-mt7530-get-cpu-port-via-dp-cpu_dp-instead-of.patch";
    }
    {
      name = "0034-drm-rockchip-Fix-Kconfig-dependencies-for-display-po";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0034-drm-rockchip-Fix-Kconfig-dependencies-for-display-po.patch";
    }
    {
      name = "0035-drm-rockchip-remove-unneeded-semicolon-from-vop2-dri";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0035-drm-rockchip-remove-unneeded-semicolon-from-vop2-dri.patch";
    }
    {
      name = "0036-drm-rockchip-Fix-spelling-mistake-aligened-aligned";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0036-drm-rockchip-Fix-spelling-mistake-aligened-aligned.patch";
    }
    # {
    #   name = "0038-drm-Drop-drm_edid.h-from-drm_crtc.h";
    #   patch = "${lede}/target/linux/rockchip/patches-5.19/0038-drm-Drop-drm_edid.h-from-drm_crtc.h.patch";
    # }
    {
      name = "0039-drm-rockchip-vop-Don-t-crash-for-invalid-duplicate_s";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0039-drm-rockchip-vop-Don-t-crash-for-invalid-duplicate_s.patch";
    }
    {
      name = "0042-phy-rockchip-inno-usb2-Prevent-incorrect-error-on-pr";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0042-phy-rockchip-inno-usb2-Prevent-incorrect-error-on-pr.patch";
    }
    {
      name = "0044-dt-bindings-phy-rockchip-add-PCIe-v3-phy";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0044-dt-bindings-phy-rockchip-add-PCIe-v3-phy.patch";
    }
    {
      name = "0045-dt-bindings-soc-grf-add-pcie30-phy-pipe-grf";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0045-dt-bindings-soc-grf-add-pcie30-phy-pipe-grf.patch";
    }
    {
      name = "0046-phy-rockchip-Support-PCIe-v3";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0046-phy-rockchip-Support-PCIe-v3.patch";
    }
    {
      name = "0047-arm64-dts-rockchip-rk3568-Add-PCIe-v3-nodes";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0047-arm64-dts-rockchip-rk3568-Add-PCIe-v3-nodes.patch";
    }
    {
      name = "0048-arm64-dts-rockchip-Add-PCIe-v3-nodes-to-BPI-R2-Pro";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0048-arm64-dts-rockchip-Add-PCIe-v3-nodes-to-BPI-R2-Pro.patch";
    }
    {
      name = "0050-arm64-dts-rk356x-fix-upper-usb-port-on-BPI-R2-Pro";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0050-arm64-dts-rk356x-fix-upper-usb-port-on-BPI-R2-Pro.patch";
    }
    {
      name = "0051-rockchip-add-pci3-for-rock3-a";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0051-rockchip-add-pci3-for-rock3-a.patch";
    }
    {
      name = "0052-rockchip-add-FriendlyElec-NanoPi-R5S-rk3568-board";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0052-rockchip-add-FriendlyElec-NanoPi-R5S-rk3568-board.patch";
    }
    {
      name = "0053-rockchip-use-system-LED-for-OpenWrt";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0053-rockchip-use-system-LED-for-OpenWrt.patch";
    }
    {
      name = "0054-arm64-rockchip-add-OF-node-for-USB-eth-on-NanoPi-R2S";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0054-arm64-rockchip-add-OF-node-for-USB-eth-on-NanoPi-R2S.patch";
    }
    {
      name = "0055-rockchip-rk3328-add-support-for-FriendlyARM-NanoPi-N";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0055-rockchip-rk3328-add-support-for-FriendlyARM-NanoPi-N.patch";
    }
    {
      name = "0057-arm64-dts-rockchip-add-hardware-random-number-genera";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0057-arm64-dts-rockchip-add-hardware-random-number-genera.patch";
    }
    {
      name = "0058-PM-devfreq-rockchip-add-devfreq-driver-for-rk3328-dmc";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0058-PM-devfreq-rockchip-add-devfreq-driver-for-rk3328-dmc.patch";
    }
    {
      name = "0059-clk-rockchip-support-setting-ddr-clock-via-SIP-Version-2-";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0059-clk-rockchip-support-setting-ddr-clock-via-SIP-Version-2-.patch";
    }
    {
      name = "0060-PM-devfreq-rockchip-dfi-add-more-soc-support";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0060-PM-devfreq-rockchip-dfi-add-more-soc-support.patch";
    }
    {
      name = "0061-arm64-dts-rockchip-rk3328-add-dfi-node";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0061-arm64-dts-rockchip-rk3328-add-dfi-node.patch";
    }
    {
      name = "0062-arm64-dts-nanopi-r2s-add-rk3328-dmc-relate-node";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0062-arm64-dts-nanopi-r2s-add-rk3328-dmc-relate-node.patch";
    }
    {
      name = "0105-nanopi-r4s-sd-signalling";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0105-nanopi-r4s-sd-signalling.patch";
    }
    {
      name = "0107-mmc-core-set-initial-signal-voltage-on-power-off";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0107-mmc-core-set-initial-signal-voltage-on-power-off.patch";
    }
    {
      name = "0900-arm-boot-add-dts-files";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0900-arm-boot-add-dts-files.patch";
    }
    {
      name = "0901-rockchip-rk3399-overclock-to-2.2-1.8-GHz-for-NanoPi4";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0901-rockchip-rk3399-overclock-to-2.2-1.8-GHz-for-NanoPi4.patch";
    }
    {
      name = "0902-arm64-dts-rockchip-add-more-cpu-operating-points-for";
      patch = "${lede}/target/linux/rockchip/patches-5.19/0902-arm64-dts-rockchip-add-more-cpu-operating-points-for.patch";
    }
  ];

  extraMeta.branch = "5.19";
})
