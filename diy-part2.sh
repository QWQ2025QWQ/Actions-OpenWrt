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

# Enable ccache to speed up subsequent builds
echo 'CONFIG_CCACHE=y' >> .config

# Modify default theme
sed -i 's/+luci-theme-bootstrap/+luci-theme-alpha/g' feeds/luci/collections/luci-light/Makefile
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/99-luci-theme-alpha << 'EOF'
#!/bin/sh
uci set luci.main.mediaurlbase=/luci-static/alpha
uci commit luci
exit 0
EOF

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
