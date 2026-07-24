#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

set -euo pipefail

# Add a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add custom packages
git clone https://v6.gh-proxy.org/https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
