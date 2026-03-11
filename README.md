# NetSpecter

NetSpecter — лёгкий менеджер VPN‑маршрутизации для **OpenWrt**, построенный на базе **sing-box**.

Проект позволяет:
- импортировать VPN‑ссылки
- использовать ссылки на VPN‑подписки
- направлять трафик через VPN
- обходить блокировки
- управлять всем через веб‑интерфейс **LuCI**

NetSpecter оптимизирован для роутеров с небольшим объёмом памяти и слабым процессором.

---

# Основные возможности

- поддержка **VLESS**
- поддержка **Trojan**
- поддержка **VPN подписок**
- режим **Global**
- режим **Selective**
- режим **Russia Mode**
- поддержка Telegram
- поддержка Google и YouTube
- автоматический watchdog перезапуск
- ночное обслуживание системы
- интерфейс на русском и английском
- оптимизация для слабых роутеров

---

# Поддерживаемые версии OpenWrt

Работает на:

- OpenWrt 23.x
- OpenWrt 24.x
- OpenWrt 25.x

---

# Установка

## 1. Подключение к роутеру

Подключитесь к роутеру через SSH.

Пример:

ssh root@192.168.1.1

Если используется Windows — можно использовать **PuTTY**.

---

## 2. Установка NetSpecter

Выполните команду:

sh -c "$(wget -qO- https://raw.githubusercontent.com/NetSpecter-Project/netspecter/main/install.sh)"

или

curl -s https://raw.githubusercontent.com/NetSpecter-Project/netspecter/main/install.sh | sh

---

## 3. Выбор настроек

Установщик предложит:

1) Русский
2) English

Выберите язык интерфейса.

Далее будет вопрос:

Включить ночной перезапуск?

Это помогает:
- очищать DNS‑кэш
- обновлять соединения
- предотвращать зависания VPN

---

## 4. После установки

Откройте веб‑интерфейс роутера:

http://192.168.1.1

Перейдите в меню:

Services → NetSpecter

---

# Использование

Можно:

### добавить VPN ссылку

vless://
trojan://

### добавить ссылку на подписку

https://example.com/subscription

После обновления подписки появится список серверов.

---

### режимы маршрутизации

Global  
Selective  
Russia Mode

---

### Russia Mode

Через VPN идут только сервисы, которые блокируются:

- Telegram
- YouTube
- Google
- Twitter / X
- Discord
- Facebook
- Instagram
- Twitch

---

# Ночной maintenance

Если функция включена, NetSpecter:

- очищает кэш
- перезапускает туннель
- обновляет соединения

По умолчанию выполняется в:

02:00

---

# Команды CLI

netspecter start
netspecter stop
netspecter restart
netspecter status
netspecter maintenance

---

# GitHub

https://github.com/NetSpecter-Project/netspecter

---

# English

NetSpecter is a lightweight VPN routing manager for **OpenWrt** built on **sing-box**.

It allows importing VPN links or subscription URLs and routing traffic through VPN with minimal CPU and RAM usage.

---

## Features

- VLESS support
- Trojan support
- VPN subscription URLs
- Global routing
- Selective routing
- Russia Mode routing
- Telegram routing
- Google / YouTube routing
- Watchdog auto restart
- Nightly maintenance
- RU / EN interface

---

## Installation

Run on router:

sh -c "$(wget -qO- https://raw.githubusercontent.com/NetSpecter-Project/netspecter/main/install.sh)"

or

curl -s https://raw.githubusercontent.com/NetSpecter-Project/netspecter/main/install.sh | sh

After installation open:

Services → NetSpecter
