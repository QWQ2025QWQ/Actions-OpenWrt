#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

set -euo pipefail

git clone https://github.com/animegasan/luci-app-alpha-config.git package/luci-app-alpha-config
git clone https://github.com/derisamedia/luci-theme-alpha.git package/luci-theme-alpha

# 人工创建 distfeeds.list 并指向教育网镜像
mkdir -p package/base-files/files/etc/apk/repositories.d
A=$(grep '^CONFIG_TARGET_ARCH_PACKAGES=' .config | cut -d'"' -f2)
B=$(grep '^CONFIG_TARGET_BOARD=' .config | cut -d'"' -f2)
S=$(grep '^CONFIG_TARGET_SUBTARGET=' .config | cut -d'"' -f2)
V=$(grep '^CONFIG_VERSION_NUMBER=' .config | cut -d'"' -f2)
[ -z "$V" ] && V="snapshots" || V="releases/$V"
M="https://mirrors.cernet.edu.cn/openwrt/$V"

cat <<EOF > package/base-files/files/etc/apk/repositories.d/distfeeds.list
$M/targets/$B/$S/packages/packages.adb
$M/packages/$A/base/packages.adb
$M/packages/$A/luci/packages.adb
$M/packages/$A/packages/packages.adb
$M/packages/$A/routing/packages.adb
$M/packages/$A/telephony/packages.adb
$M/packages/$A/video/packages.adb
EOF

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.3/g' package/base-files/files/bin/config_generate

cp "$GITHUB_WORKSPACE/robin.png" package/luci-theme-alpha/luasrc/background/dashboard.png
cp "$GITHUB_WORKSPACE/robin.png" package/luci-theme-alpha/luasrc/background/login.png

# Enable ccache to speed up subsequent builds
echo 'CONFIG_CCACHE=y' >> .config

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-alpha/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-alpha/g' feeds/luci/collections/luci-light/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-alpha/g' feeds/luci/collections/luci-nginx/Makefile

# Modify hostname
sed -i 's/OpenWrt/QWQ2025-Router/g' package/base-files/files/bin/config_generate

# 预装 RustDesk Server (自动下载最新版并放入 /usr/bin)
TARGET_ARCH=$(grep '^CONFIG_TARGET_ARCH_PACKAGES=' .config | cut -d'"' -f2)
A="amd64"; [[ "$TARGET_ARCH" == *aarch64* ]] && A="arm64v8"; [[ "$TARGET_ARCH" == *arm* ]] && A="armv7"
V=$(curl -sL https://api.github.com/repos/rustdesk/rustdesk-server/releases/latest | grep -oP '(?<="tag_name": ")[^"]+')
curl -sL https://github.com/rustdesk/rustdesk-server/releases/download/$V/rustdesk-server-linux-$A.zip -o /tmp/r.zip
unzip -qo /tmp/r.zip -d /tmp/r
mkdir -p package/base-files/files/usr/bin
cp /tmp/r/$A/hbbs /tmp/r/$A/hbbr package/base-files/files/usr/bin/ && chmod +x package/base-files/files/usr/bin/hb*
