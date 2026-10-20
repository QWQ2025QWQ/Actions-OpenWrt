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

git clone https://github.com/derisamedia/luci-theme-alpha.git package/luci-theme-alpha

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.3/g' package/base-files/files/bin/config_generate

cp "$GITHUB_WORKSPACE/robin.png" package/luci-theme-alpha/luasrc/background/background.png
cp "$GITHUB_WORKSPACE/robin.png" package/luci-theme-alpha/luasrc/background/login.png

# Modify default theme to alpha
sed -i 's/luci-theme-bootstrap/luci-theme-alpha/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-alpha/g' feeds/luci/collections/luci-light/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-alpha/g' feeds/luci/collections/luci-nginx/Makefile

# Enable ccache to speed up subsequent builds
echo 'CONFIG_CCACHE=y' >> .config

# Modify default theme

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# 修复 uhttpd 因 ucode STATUS_BREAK 导致的编译错误
UCODE_MAKEFILE=$(find . -path "*/ucode/Makefile" -not -path "./build_dir/*" | head -n 1)
if [ -n "$UCODE_MAKEFILE" ]; then
    sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=ca796d7/' "$UCODE_MAKEFILE"
    # 同时更新源码日期，确保构建系统能识别到版本变化
    sed -i "s/PKG_SOURCE_DATE:=.*/PKG_SOURCE_DATE:=$(date +%Y-%m-%d)/" "$UCODE_MAKEFILE"
    echo "ucode PKG_SOURCE_VERSION 已更新至 ca796d7"
fi
