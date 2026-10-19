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
