include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-netspecter
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_LICENSE:=MIT
PKG_MAINTAINER:=xxkxail <https://github.com/NetSpecter-Project/netspecter>

LUCI_TITLE:=LuCI support for NetSpecter sing-box client
LUCI_DESCRIPTION:=Minimalist sing-box powered anti-censorship client for OpenWrt routers.
LUCI_PKGARCH:=all
LUCI_DEPENDS:= \
	+luci-base \
	+rpcd \
	+rpcd-mod-uci \
	+sing-box \
	+dnsmasq-full \
	+ca-bundle \
	+uclient-fetch \
	+ip-full \
	+kmod-tun \
	+kmod-nf-tproxy \
	+kmod-nft-core \
	+kmod-nft-fib \
	+kmod-nft-socket \
	+kmod-nft-tproxy

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/conffiles
/etc/config/netspecter
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] && exit 0

chmod 0755 \
	/etc/init.d/netspecter \
	/usr/libexec/rpcd/luci.netspecter \
	/usr/libexec/luci-app-netspecter/core/build-config.sh \
	/usr/libexec/luci-app-netspecter/service/healthcheck.sh \
	/usr/libexec/luci-app-netspecter/dns/dnsmasq.sh \
	/usr/libexec/luci-app-netspecter/maintenance/cron-sync.sh \
	/usr/libexec/luci-app-netspecter/maintenance/log-rotate.sh \
	/usr/libexec/luci-app-netspecter/updater/check-github.sh \
	2>/dev/null || true

/etc/init.d/rpcd reload >/dev/null 2>&1 || true
exit 0
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] && exit 0

/usr/libexec/luci-app-netspecter/dns/dnsmasq.sh restore >/dev/null 2>&1 || true
/usr/libexec/luci-app-netspecter/maintenance/cron-sync.sh clear >/dev/null 2>&1 || true
/etc/init.d/netspecter stop >/dev/null 2>&1 || true
/etc/init.d/netspecter disable >/dev/null 2>&1 || true
exit 0
endef

# call BuildPackage - OpenWrt buildroot signature
