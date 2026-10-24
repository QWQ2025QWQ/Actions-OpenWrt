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

# 开机自动修改镜像源 (放在源码根目录的 files 中)
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/99-change-mirror << 'EOF'
#!/bin/sh
# 等待网络就绪
sleep 5
# 替换为镜像站
sed -i 's#downloads.openwrt.org#mirrors.ustc.edu.cn/openwrt#g' /etc/apk/repositories.d/distfeeds.list
exit 0
EOF
chmod +x files/etc/uci-defaults/99-change-mirror

# Modify default IP
#sed -i 's/192.168.1.1/192.168.1.3/g' package/base-files/files/bin/config_generate

# Enable ccache to speed up subsequent builds
echo 'CONFIG_CCACHE=y' >> .config

# Modify hostname
#sed -i 's/OpenWrt/QWQ2025-Router/g' package/base-files/files/bin/config_generate

# 将 apk 源配置文件加入升级保留名单
echo '/etc/apk/repositories.d/distfeeds.list' >> package/base-files/files/etc/sysupgrade.conf
