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

# ---------- Argon 3.0 主题：自定义品牌资源 ----------
# 注意：Argon 3.0 将自定义图标放在 root 目录的 branding 下，而不是 htdocs 的 icon 下
ARGON_BRANDING="package/luci-theme-argon/root/www/luci-static/argon/branding"
ARGON_BG="package/luci-theme-argon/root/www/luci-static/argon/background"

# 确保目标目录存在（CI 编译时防止 cp 失败）
mkdir -p "$ARGON_BRANDING"
mkdir -p "$ARGON_BG"

# 复制图标
cp "$GITHUB_WORKSPACE/custom/icon16.png"         "$ARGON_BRANDING/favicon-16x16.png"
cp "$GITHUB_WORKSPACE/custom/icon32.png"         "$ARGON_BRANDING/favicon-32x32.png"
cp "$GITHUB_WORKSPACE/custom/icon144.png"        "$ARGON_BRANDING/apple-icon-144x144.png"
cp "$GITHUB_WORKSPACE/custom/icon192.png"        "$ARGON_BRANDING/android-icon-192x192.png"
cp "$GITHUB_WORKSPACE/custom/icon48_48x48.ico"   "$ARGON_BRANDING/favicon.ico"
cp "$GITHUB_WORKSPACE/custom/icon192.png"         "$ARGON_BRANDING/logo.png"
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
sed -i 's/OpenWrt/Xtreme-Link/g' package/base-files/files/bin/config_generate

# 仅关闭：容器支持、命名空间隔离、安全计算模式
perl -i -pe '
  s/^CONFIG_KERNEL_(CGROUPS|CGROUP_[A-Z0-9_]+|CPUSETS|CPUSETS_V1|PROC_PID_CPUSET|MEMCG|MEMCG_KMEM|MEMCG_V1|FAIR_GROUP_SCHED|CFS_BANDWIDTH|RT_GROUP_SCHED|BLK_CGROUP|CFQ_GROUP_IOSCHED|BLK_DEV_THROTTLING|BLK_DEV_THROTTLING_LOW|DEBUG_BLK_CGROUP|NET_CLS_CGROUP|CGROUP_NET_CLASSID|CGROUP_NET_PRIO|NAMESPACES|UTS_NS|IPC_NS|USER_NS|PID_NS|NET_NS|TIME_NS|SECCOMP_FILTER|SECCOMP)=y$/# CONFIG_KERNEL_$1 is not set/;
  s/^CONFIG_USE_SECCOMP=y$/# CONFIG_USE_SECCOMP is not set/;
' .config
