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

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.3/g' package/base-files/files/bin/config_generate

# Modify default timezone
sed -i "s/set system.@system\[-1\].timezone='GMT0'/set system.@system[-1].timezone='CST-8'/" \
	package/base-files/files/bin/config_generate
sed -i "s/set system.@system\[-1\].zonename='UTC'/set system.@system[-1].zonename='Asia\/Shanghai'/" \
	package/base-files/files/bin/config_generate

# Modify default LuCI language
sed -i "s/option lang 'auto'/option lang 'zh_cn'/" \
	feeds/luci/modules/luci-base/root/etc/config/luci

# Modify default theme to alpha
sed -i 's/luci-theme-bootstrap/luci-theme-alpha/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-alpha/g' feeds/luci/collections/luci-light/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-alpha/g' feeds/luci/collections/luci-nginx/Makefile

# Enable ccache to speed up subsequent builds
echo 'CONFIG_CCACHE=y' >> .config

# Modify default theme

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
