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

# 拉取 Argon 主题及配置插件
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# ---------- Argon 主题：自定义 favicon / 背景图 ----------
ARGON_ICON="package/luci-theme-argon/htdocs/luci-static/argon/icon"
ARGON_BG="package/luci-theme-argon/htdocs/luci-static/argon/background"

cp "$GITHUB_WORKSPACE/custom/icon16.png"         "$ARGON_ICON/favicon-16x16.png"
cp "$GITHUB_WORKSPACE/custom/icon32.png"         "$ARGON_ICON/favicon-32x32.png"
cp "$GITHUB_WORKSPACE/custom/icon144.png"        "$ARGON_ICON/apple-icon-144x144.png"
cp "$GITHUB_WORKSPACE/custom/icon192.png"        "$ARGON_ICON/android-icon-192x192.png"
cp "$GITHUB_WORKSPACE/custom/icon48_48x48.ico"   "$ARGON_ICON/favicon.ico"
cp "$GITHUB_WORKSPACE/custom/bg.jpg"             "$ARGON_BG/background.jpg"

# Modify default IP
sed -i 's/192.168.1.1/192.168.23.1/g' package/base-files/files/bin/config_generate

# Enable ccache to speed up subsequent builds
echo 'CONFIG_CCACHE=y' >> .config

# Modify default theme

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
