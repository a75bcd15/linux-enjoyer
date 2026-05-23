# Навигация по репозиторию
Здесь собраны мои конспекты и конфиги, которые я использую. Описываю проблемы, с которыми сталкивалась, и пути их решения. 

Буквально вчера поставила Arch Linux в качестве основной системы. Буду ломать и строить, чтобы разобраться как всё устроено. Очень много пользуюсь нейронками, но хочу в будущем возвращаться к старым заметкам и улучшать их.

## Linux
- [Виртуализация](vm.md);
- [Установка Arch](first-steps.md);
- [Настройка рабочего стола](hyprland.md);
- [Файловая система Linux](filesystem.md);
- [Основные команды терминала](terminal.md);
- [Снимки файловой системы со Snapper](snapper.md);
- [Введение в Bash](bash-basics.md).

## На заметку
- [Погружение в Git](git.md);
- [Установка программ](apps.md).

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
