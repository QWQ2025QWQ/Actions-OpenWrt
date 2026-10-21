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

sed -i 's#http[s]*://downloads.openwrt.org#https://mirrors.cernet.edu.cn/openwrt#g' package/base-files/files/etc/apk/repositories.d/distfeeds.list || true

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
V=$(curl -sL https://api.github.com/repos/rustdesk/rustdesk-server/releases/latest | grep -oP '(?<="tag_name": ")[^"]+')
A="amd64"; [[ "$ARCH" == aarch64* ]] && A="arm64v8"; [[ "$ARCH" == arm* ]] && A="armv7"
curl -sL https://github.com/rustdesk/rustdesk-server/releases/download/$V/rustdesk-server-linux-$A.zip -o /tmp/r.zip
unzip -qo /tmp/r.zip -d /tmp/r && mkdir -p package/base-files/files/usr/bin
cp /tmp/r/$A/hbbs /tmp/r/$A/hbbr package/base-files/files/usr/bin/ && chmod +x package/base-files/files/usr/bin/hb*
