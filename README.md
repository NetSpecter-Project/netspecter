```text
 _   _      _   ____                  _            
| \ | | ___| |_/ ___| _ __   ___  ___| |_ ___ _ __
|  \| |/ _ \ __\___ \| '_ \ / _ \/ __| __/ _ \ '__|
| |\  |  __/ |_ ___) | |_) |  __/ (__| ||  __/ |   
|_| \_|\___|\__|____/| .__/ \___|\___|\__\___|_|   
                     |_|                            
[ developer: xxkxail ]
```

# NetSpecter

`luci-app-netspecter` package repository for OpenWrt.

`NetSpecter` is a modern LuCI application for OpenWrt 25.x+ built around one engine only: `sing-box`.

The project is designed as a lightweight but serious alternative to heavyweight anti-censorship stacks. It focuses on clear routing modes, clean DNS leak protection, fast LuCI UX, and a predictable OpenWrt-native integration through `procd`, `rpcd`, `dnsmasq`, `cron`, and `apk`.

## Russian

### Что это такое

`NetSpecter` — это open-source плагин для OpenWrt с современным LuCI-интерфейсом, который помогает:

- импортировать ссылки и подписки `VLESS`, `VMess`, `Trojan`, `Shadowsocks`
- собирать итоговый `sing-box` конфиг автоматически
- проксировать весь трафик или только нужные направления
- исключать DNS Leak через локальный listener и интеграцию с `dnsmasq`
- управлять сервисом через `procd`, LuCI и `rpcd`
- проверять новые релизы через GitHub API

### Ключевые возможности

- Только `sing-box` в качестве backend. Без лишних прокси-движков и смешанных конфигураций.
- Поддержка `VLESS`, `VMess`, `Trojan`, `Shadowsocks`.
- Поддержка `Reality`-параметров в `VLESS`-ссылках.
- URL-подписки и импорт одиночных ссылок через LuCI.
- Режимы маршрутизации:
  - `Global`
  - `Bypass RU`
  - `Custom`
- GeoIP / GeoSite логика для умного обхода блокировок в РФ.
- Защищенный DNS через `Cloudflare`, `Google`, `Quad9`, `AdGuard` или `Custom`.
- Перенаправление `dnsmasq` на локальный `127.0.0.1:6053` для защиты от DNS Leak.
- Статус сервиса в LuCI с проверкой процесса и туннеля.
- `cron`-обслуживание: очистка кэша, ротация логов, плановый reboot.
- OTA-проверка новых версий через GitHub API.
- OpenWrt 25.x+ friendly packaging с выходом в `.apk`.

### Почему NetSpecter

`NetSpecter` не пытается быть “комбайном на все случаи”. Вместо этого проект делает ставку на:

- минималистичную архитектуру
- понятный UCI
- современный JS LuCI
- прозрачную генерацию конфигурации
- аккуратную системную интеграцию

Если вам нужен продукт уровня PassWall или HomeProxy, но с более узкой, предсказуемой и поддерживаемой архитектурой вокруг одного `sing-box`, `NetSpecter` именно про это.

### Установка одной командой

Установка последнего релиза напрямую с GitHub Releases:

```sh
APK_URL="$(wget -qO- https://api.github.com/repos/NetSpecter-Project/netspecter/releases/latest | sed -n 's#.*\"browser_download_url\": \"\\(.*luci-app-netspecter.*_all\\.apk\\)\".*#\\1#p' | head -n1)" && wget -O /tmp/luci-app-netspecter.apk "$APK_URL" && apk add --allow-untrusted /tmp/luci-app-netspecter.apk
```

Примечания:

- пакет `luci-app-netspecter` собирается как `all.apk`
- зависимости (`sing-box`, `dnsmasq-full`, `kmod-tun`, `kmod-nft-tproxy`, `ca-bundle` и другие) подтягиваются через `apk`
- для работы нужны стандартные OpenWrt repositories и доступ к сети

### Что увидит пользователь в LuCI

- Вкладка `Главная`: крупный live-статус, toggle включения, быстрый обзор состояния сервиса.
- Вкладка `Узлы`: импорт ссылок, URL-подписок и выбор активного узла.
- Вкладка `Маршрутизация`: `Global`, `Bypass RU`, `Custom`, GeoIP / GeoSite и ручные домены/IP.
- Вкладка `DNS`: выбор провайдера, `Quad9` / `Cloudflare` / `Google` / `AdGuard`, anti-leak.
- Вкладка `Обслуживание`: cron, cache cleanup, reboot, log rotation.
- Вкладка `О плагине`: версия, статус, разработчик, Telegram, проверка обновлений и changelog.

### Скриншоты

Для GitHub-страницы рекомендуется положить изображения в `docs/screenshots/` и использовать такие файлы:

- `docs/screenshots/overview-status.png`
  - Главная вкладка с крупным зеленым статусом `Подключено`, toggle и краткой сводкой.
- `docs/screenshots/nodes-import.png`
  - Вкладка импорта URL-подписок и одиночных ссылок `VLESS / Trojan / VMess / SS`.
- `docs/screenshots/routing-bypass-ru.png`
  - Вкладка маршрутизации с включенным режимом `Bypass RU`.
- `docs/screenshots/dns-quad9.png`
  - Вкладка DNS с выбранным `Quad9`, локальным listener и anti-leak настройками.
- `docs/screenshots/about-update.png`
  - Вкладка `О плагине` с результатом проверки обновлений и changelog последнего релиза.

### Архитектура

- `LuCI JS` для интерфейса
- `rpcd` для связи фронтенда с системой
- `procd` для управления демоном `sing-box`
- генератор конфига `sing-box` из UCI
- интеграция с `dnsmasq`
- планировщик обслуживания через `cron`
- OTA-check через GitHub API

### Поддерживаемые сценарии

- Полный туннель для всего роутера
- Умный обход блокировок для РФ
- Списки пользовательских доменов и IP
- Reality/VLESS-конфигурации
- Quad9 и другие защищенные DNS-провайдеры
- Обновление узлов из URL-подписок

## English

### Overview

`NetSpecter` is an open-source LuCI application for OpenWrt 25.x+ that provides a clean anti-censorship workflow around a single backend: `sing-box`.

It is built for users who want a smaller and more predictable system than a “kitchen sink” proxy suite, while still keeping serious routing, DNS, and service-management capabilities.

### Highlights

- `sing-box` only. No mixed engines, no split backend model.
- Support for `VLESS`, `VMess`, `Trojan`, `Shadowsocks`.
- `Reality` support for `VLESS` links.
- Subscription URL import and manual link import from LuCI.
- Routing modes:
  - `Global`
  - `Bypass RU`
  - `Custom`
- GeoIP / GeoSite-based smart routing.
- Encrypted DNS via `Cloudflare`, `Google`, `Quad9`, `AdGuard`, or `Custom`.
- Local DNS listener and `dnsmasq` forwarding to prevent DNS leaks.
- `procd` service supervision and runtime status checks.
- `cron` maintenance jobs for cache cleanup, log rotation, and scheduled reboot.
- GitHub API based OTA release checks from LuCI.
- Native `.apk` packaging for modern OpenWrt.

### Positioning

`NetSpecter` aims to be a serious LuCI package, not just a wrapper around random shell snippets.

The project focuses on:

- clean UCI design
- modern LuCI JS views
- predictable service lifecycle
- transparent config generation
- solid system integration

This makes it a strong lightweight alternative in the same conversation as PassWall or HomeProxy, while keeping the codebase intentionally narrower and easier to audit.

### One-line installation

Install the latest GitHub Release package with a single command:

```sh
APK_URL="$(wget -qO- https://api.github.com/repos/NetSpecter-Project/netspecter/releases/latest | sed -n 's#.*\"browser_download_url\": \"\\(.*luci-app-netspecter.*_all\\.apk\\)\".*#\\1#p' | head -n1)" && wget -O /tmp/luci-app-netspecter.apk "$APK_URL" && apk add --allow-untrusted /tmp/luci-app-netspecter.apk
```

Notes:

- `luci-app-netspecter` is packaged as `all.apk`
- runtime dependencies are resolved by `apk`
- your router should have normal OpenWrt repositories configured

### LuCI tabs

- `Overview`: live service state, master toggle, operational summary
- `Nodes`: subscription import, manual link import, active node selection
- `Routing`: `Global`, `Bypass RU`, `Custom`, GeoIP / GeoSite and user rules
- `DNS`: provider selection, leak protection, local DNS listener
- `Maintenance`: cache cleanup, reboot schedule, log settings
- `About`: version, developer block, Telegram link, release check, changelog

### Screenshot plan

For a strong GitHub presentation, place screenshots in `docs/screenshots/`:

- `overview-status.png`
  - Overview page with a large green `Connected` state.
- `nodes-import.png`
  - Subscription and manual import workflow.
- `routing-bypass-ru.png`
  - Bypass RU mode with Geo rules.
- `dns-quad9.png`
  - Quad9 DNS configuration with anti-leak setup.
- `about-update.png`
  - About page with GitHub release check and changelog preview.

### Core stack

- LuCI JS frontend
- `rpcd` integration
- `procd` service management
- UCI-driven `sing-box` config generation
- `dnsmasq` DNS forwarding
- `cron` maintenance
- GitHub API based OTA checks

### Use cases

- route all router traffic through one tunnel
- bypass Russian destinations directly while proxying blocked resources
- proxy only user-defined domains and IP ranges
- deploy Reality-ready `VLESS` links
- run Quad9 or other encrypted DNS providers
- maintain a subscription-driven node inventory with a clean LuCI workflow
