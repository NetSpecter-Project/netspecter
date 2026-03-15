#!/bin/sh
set -eu

# Определение менеджера пакетов
if command -v apk >/dev/null; then
    PKG_INSTALL="apk add"
    PKG_UPDATE="apk update"
else
    PKG_INSTALL="opkg install"
    PKG_UPDATE="opkg update"
fi

echo "📦 Обновление системы через $PKG_UPDATE..."
$PKG_UPDATE

echo "⚙️ Установка зависимостей..."
$PKG_INSTALL curl sing-box luci-base rpcd uci dnsmasq-full ca-bundle kmod-tun kmod-nft-tproxy

ORG="NetSpecter-Project"
REPO="netspecter"
TMPDIR="/tmp/netspecter-install"
mkdir -p "$TMPDIR"

echo "🔍 Поиск последней версии NetSpecter..."
URLS=$(curl -s https://api.github.com/repos/${ORG}/${REPO}/releases/latest | grep "browser_download_url" | cut -d '"' -f 4)
DOWNLOAD_URL=$(echo "$URLS" | grep "_all.apk" | head -n 1)

echo "📥 Загрузка и установка..."
curl -L -o "$TMPDIR/netspecter.apk" "$DOWNLOAD_URL"
$PKG_INSTALL "$TMPDIR/netspecter.apk"

echo "✅ Готово! NetSpecter установлен."
/etc/init.d/netspecter enable || true
/etc/init.d/netspecter restart || true
