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
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-light/Makefile 2>/dev/null || true
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile 2>/dev/null || true

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# 仅关闭：容器支持、命名空间隔离、安全计算模式
perl -i -pe '
  s/^CONFIG_KERNEL_(CGROUPS|CGROUP_[A-Z0-9_]+|CPUSETS|CPUSETS_V1|PROC_PID_CPUSET|MEMCG|MEMCG_KMEM|MEMCG_V1|FAIR_GROUP_SCHED|CFS_BANDWIDTH|RT_GROUP_SCHED|BLK_CGROUP|CFQ_GROUP_IOSCHED|BLK_DEV_THROTTLING|BLK_DEV_THROTTLING_LOW|DEBUG_BLK_CGROUP|NET_CLS_CGROUP|CGROUP_NET_CLASSID|CGROUP_NET_PRIO|NAMESPACES|UTS_NS|IPC_NS|USER_NS|PID_NS|NET_NS|TIME_NS|SECCOMP_FILTER|SECCOMP)=y$/# CONFIG_KERNEL_$1 is not set/;
  s/^CONFIG_USE_SECCOMP=y$/# CONFIG_USE_SECCOMP is not set/;
' .config
