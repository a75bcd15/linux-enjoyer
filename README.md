# Навигация по репозиторию
Здесь собраны мои конспекты и конфиги, которые я использую. Описываю проблемы, с которыми сталкивалась, и пути их решения. 

## Linux
### Основы
- [Виртуализация](vm.md);
- [Файловая система Linux](filesystem.md);
- [Основные команды терминала](terminal.md);
- [Введение в Bash](bash-basics.md);
- [Погружение в Git](git.md);
- [Docker](docker.md).

### Arch
- [Установка Arch](first-steps.md);
- [Установка программ](apps.md);
- [Снимки файловой системы со Snapper](snapper.md);
- [Настройка рабочего стола](hyprland.md).

## Компьютерные сети
1. Введение:
    - [Модели OSI и TCP/IP](net/md/osi--tcp-ip.md);
    - [Виды сетевого оборудования](net/md/net-equip.md);
    - [Виды топологии сети](net/md/topologies.md);
    - [Виды сетевого трафика](net/md/net-trffc.md);
    - [Протокол](net/md/protocol.md);
    - [Порт](net/md/port.md);
    - [Анализатор пакетов](net/md/sniffer.md);
    - [Беспроводные сети](net/md/wlan.md).
2. Протоколы сетевого уровня:
    - [ARP](net/md/arp.md);
    - [ICMP](net/md/icmp.md);
    - [IP](net/md/ip.md): [IPv4](net/md/ipv4.md) и [IPv6](net/md/ipv6.md).
3. Протоколы транспортного уровня:
    - [TCP](net/md/tcp.md) и его [элементы](net/md/tcp-reliability.md);
    - [UDP](net/md/udp.md).
4. Протоколы прикладного уровня:
    - [SSH](net/md/ssh.md);
    - [DHCP](net/md/dhcp.md);
    - [DNS](net/md/dns.md);
    - [HTTP](net/md/http.md);
    - [SMTP](net/md/smtp.md).
5. Сетевые инструменты:
    - [ping](net/md/ping.md) отправляет эхо-запросы и ждёт эхо-ответов;
    - [traceroute](net/md/traceroute.md) определяет маршрут пакетов;
    - [wireshark](net/md/wireshark.md) перехватывает сетевые пакеты в графическом интерфейсе;
    - [tcpdump](net/md/tcpdump-tshark.md) перехватывает сетевые пакеты в командной строке;
    - [nmap](net/md/nmap.md) ищет узлы и открытые порты в сети.

## Программирование
   - [Основы Python: условия, циклы, функции](py-basics-1.md);
   - [Продолжение Python: библиотеки, работа с файлами, venv](py-basics-2.md);
   - [Алгоритмы](algorithms.md);
   - [Линейная алгебра на Python](py-algebra.md);
   - [OSINT с помощью Python](py-osint.md).

## Использованные источники
### Ссылки

1. [Курс Stepik - Поколение Python](https://stepik.org/course/58852/promo);
2. [Python for OSINT. 21-day course for beginners](https://github.com/cipher387/python-for-OSINT-21-days/tree/main).

### Литература

| № | НАЗВАНИЕ | АВТОР | ГОД |
| - | :--- | :--- | :--- |
| 1 | [A Byte of Python](https://python.swaroopch.com/) | Swaroop C. | 2020 |
| 2 | [Грокаем алгоритмы](https://www.piter.com/product/grokaem-algoritmy-illyustrirovannoe-posobie-dlya-programmistov-i-lyubopytstvuyuschih-2) | Адитья Бхаргава | 2017 |
| 3 | [Devpractice Team. Линейная алгебра на Python](https://devpractice.ru/book-linalg-python/) | Абдрахманов М.И. | 2019 |
| 4 | [Анализ пакетов: практическое руководство по использованию Wireshark и tcpdump для решения реальных проблем в локальных сетях](https://nostarch.com/packetanalysis3) | Крис Сандерс | 2019 |
| 5 | [Head First Git](https://www.oreilly.com/library/view/head-first-git/9781492092506/) | Раджу Ганди | 2022 |