#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# golang 1.21.x
# rm -rf feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 21.x feeds/packages/lang/golang

# remove v2ray-geodata package from feeds (openwrt-22.03 & master)
rm -rf feeds/packages/net/v2ray-geodata
git clone https://github.com/sbwml/v2ray-geodata feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/mosdns
find ./ | grep Makefile | grep luci-app-mosdns | xargs rm -f
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns

# Replace luci-app-ssr-plus & Depends
# git clone --depth=1 -b master https://github.com/fw876/helloworld
# Replace_package="xray-core xray-plugin v2ray-core v2ray-plugin hysteria ipt2socks microsocks redsocks2 shadowsocks-rust chinadns-ng dns2socks dns2tcp naiveproxy shadowsocksr-libev simple-obfs tcping tuic-client"
# for a in ${Replace_package}
# do
# 	echo "Replace_package=$a"
#  	rm -rf feeds/packages/net/"$a"
# 	cp -r helloworld/"$a" feeds/packages/net
# done
# rm -rf feeds/luci/applications/luci-app-ssr-plus
# cp -r helloworld/luci-app-ssr-plus feeds/luci/applications
# cp -r helloworld/shadow-tls package
# rm -rf helloworld

sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate

# Remove upx commands
#makefile_file="$({ find package|grep Makefile |sed "/Makefile./d"; } 2>"/dev/null")"
#for a in ${makefile_file}
#do
#	[ -n "$(grep "upx" "$a")" ] && sed -i "/upx/d" "$a"
#done

# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by Haiibo/g" package/lean/default-settings/files/zzz-default-settings


# 调整 ZeroTier 到 服务 菜单
sed -i 's/vpn/services/g; s/VPN/Services/g' feeds/luci/applications/luci-app-zerotier/luasrc/controller/zerotier.lua
sed -i 's/vpn/services/g' feeds/luci/applications/luci-app-zerotier/luasrc/view/zerotier/zerotier_status.htm

# 调整 Docker 到 服务 菜单
sed -i 's/"admin"/"admin", "services"/g' feeds/luci/applications/luci-app-dockerman/luasrc/controller/*.lua
sed -i 's/"admin"/"admin", "services"/g; s/admin\//admin\/services\//g' feeds/luci/applications/luci-app-dockerman/luasrc/model/cbi/dockerman/*.lua
sed -i 's/admin\//admin\/services\//g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/*.htm
sed -i 's|admin\\|admin\\/services\\|g' feeds/luci/applications/luci-app-dockerman/luasrc/view/dockerman/container.htm

# 添加删除缺少依赖
# git clone https://github.com/openwrt/firewall4.git package/firewall4
sed -i 's/ +firewall4//g' package/kenzo/homeproxy/Makefile
sed -i 's/ +kmod-nft-tproxy//g' package/kenzo/homeproxy/Makefile
sed -i 's/ +firewall4//g' package/kenzo/luci-app-homeproxy/Makefile
sed -i 's/ +kmod-nft-tproxy//g' package/kenzo/luci-app-homeproxy/Makefile

