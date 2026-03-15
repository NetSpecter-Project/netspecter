#!/bin/sh
set -eu

clear
cat << "EOF"

:: NETSPECTER CORE INITIALIZING ::
:: LOADING ROUTING ENGINE ::
:: LOADING NETWORK MODULES ::
:: SYSTEM READY ::

███╗   ██╗███████╗████████╗███████╗██████╗ ███████╗ ██████╗████████╗███████╗██████╗
████╗  ██║██╔════╝╚══██╔══╝██╔════╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔════╝██╔══██╗
██╔██╗ ██║█████╗     ██║   ███████╗██████╔╝█████╗  ██║        ██║   █████╗  ██████╔╝
██║╚██╗██║██╔══╝     ██║   ╚════██║██╔═══╝ ██╔══╝  ██║        ██║   ██╔══╝  ██╔══██╗
██║ ╚████║███████╗   ██║   ███████║██║     ███████╗╚██████╗   ██║   ███████╗██║  ██║
╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚══════╝ ╚═════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝

        NetSpecter :: Lightweight VPN routing for OpenWrt
                    Developer: xxkxail

EOF

ORG="NetSpecter-Project"
REPO="netspecter"
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

printf 'Включить ночной перезапуск? [1=Да,2=Нет] / Enable nightly restart? [1=Yes,2=No]: '
read -r NIGHT_CHOICE
NS_NIGHTLY="0"
[ "${NIGHT_CHOICE:-2}" = "1" ] && NS_NIGHTLY="1"

echo "📦 Обновление системы и установка зависимостей..."
opkg update
opkg install curl sing-box luci-base rpcd uci dnsmasq-full ca-bundle kmod-tun kmod-nft-tproxy

# Автоматический поиск последней версии APK через GitHub API
echo "🔍 Поиск последней версии NetSpecter..."
URLS=$(curl -s https://api.github.com/repos/${ORG}/${REPO}/releases/latest | grep "browser_download_url" | cut -d '"' -f 4)
DOWNLOAD_URL=$(echo "$URLS" | grep "_all.apk" | head -n 1)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "❌ Ошибка: Не удалось найти файл .apk в релизах GitHub!"
    exit 1
fi

echo "📥 Загрузка: $DOWNLOAD_URL"
curl -L -o "$TMPDIR/netspecter.apk" "$DOWNLOAD_URL"

echo "⚙️ Установка пакета..."
opkg install "$TMPDIR/netspecter.apk"

# Настройка UCI
uci set netspecter.main.language="$NS_LANG"
uci set netspecter.main.nightly_restart="$NS_NIGHTLY"
uci commit netspecter

# Запуск службы
if [ -x /etc/init.d/netspecter ]; then
  /etc/init.d/netspecter enable || true
  /etc/init.d/netspecter restart || true
fi

echo ""
echo "================================================="
echo "  NetSpecter успешно установлен / Success!"
echo "  Разработчик: xxkxail"
echo "  Доступ: Службы -> NetSpecter"
echo "================================================="
