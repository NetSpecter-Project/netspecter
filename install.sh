#!/bin/sh
set -eu

clear
cat << "EOF"

:: NETSPECTER CORE INITIALIZING ::
:: LOADING ROUTING ENGINE ::
:: LOADING NETWORK MODULES ::
:: SYSTEM READY ::

███╗   ██╗███████╗████████╗███████╗██████╗ ███████╗███████╗████████╗███████╗██████╗
████╗  ██║██╔════╝╚══██╔══╝██╔════╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔════╝██╔══██╗
██╔██╗ ██║█████╗     ██║   ███████╗██████╔╝█████╗  █████╗     ██║   █████╗  ██████╔╝
██║╚██╗██║██╔══╝     ██║   ╚════██║██╔═══╝ ██╔══╝  ██╔══╝     ██║   ██╔══╝  ██╔══██╗
██║ ╚████║███████╗   ██║   ███████║██║     ███████╗███████╗   ██║   ███████╗██║  ██║
╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝

        NetSpecter :: Lightweight VPN routing for OpenWrt
                    Developer: xxkxail

EOF

ORG="NetSpecter-Project"
REPO="netspecter"
VERSION="latest"
BASE="https://github.com/${ORG}/${REPO}/releases/${VERSION}/download"
TMPDIR="/tmp/netspecter-install"

mkdir -p "$TMPDIR"
trap 'rm -rf "$TMPDIR"' EXIT

echo "NetSpecter installer"
echo "1) Русский"
echo "2) English"
printf 'Выберите язык / Select language [1-2]: '
read -r LANG_CHOICE
NS_LANG="ru"
[ "${LANG_CHOICE:-1}" = "2" ] && NS_LANG="en"

printf 'Включить ночной перезапуск для очистки кэша и DNS? [1=Да,2=Нет] / Enable nightly restart to clear cache and DNS? [1=Yes,2=No]: '
read -r NIGHT_CHOICE
NS_NIGHTLY="0"
[ "${NIGHT_CHOICE:-2}" = "1" ] && NS_NIGHTLY="1"

opkg update
opkg install python3-light python3-json python3-urllib sing-box luci-base rpcd uci dnsmasq-full ca-bundle wget-ssl || \
opkg install python3 sing-box luci-base rpcd uci dnsmasq-full ca-bundle wget-ssl

wget -O "$TMPDIR/netspecter.ipk" "$BASE/netspecter_1.1.0-1_all.ipk"
wget -O "$TMPDIR/luci-app-netspecter.ipk" "$BASE/luci-app-netspecter_1.1.0-1_all.ipk"

opkg install "$TMPDIR/netspecter.ipk" "$TMPDIR/luci-app-netspecter.ipk"

uci set netspecter.main.language="$NS_LANG"
uci set netspecter.main.nightly_restart="$NS_NIGHTLY"
uci commit netspecter

if [ -x /etc/init.d/netspecter ]; then
  /etc/init.d/netspecter enable || true
  /etc/init.d/netspecter restart || true
fi

echo ""
echo "NetSpecter installed successfully"
echo "NetSpecter успешно установлен"
echo ""
echo "Open LuCI / Откройте LuCI:"
echo "Services -> NetSpecter"
echo ""
echo "Приятного пользования / Enjoy"
