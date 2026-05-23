# Btrfs x Snapper
- [Btrfs x Snapper](#btrfs-x-snapper)
  - [Краткая теория](#краткая-теория)
  - [Настройка](#настройка)
    - [Подготовка субтомов](#подготовка-субтомов)
    - [Настройка `/etc/fstab`](#настройка-etcfstab)
    - [Установка утилит](#установка-утилит)
    - [Инициализация конфига для root и home](#инициализация-конфига-для-root-и-home)
    - [Изменение конфигурации](#изменение-конфигурации)
    - [Автоматизация](#автоматизация)
  - [Основные команды](#основные-команды)
    - [Ручное управление](#ручное-управление)
    - [Команды Snapper](#команды-snapper)
  - [Troubleshooting](#troubleshooting)
    - [Case 0: Практика команд](#case-0-практика-команд)
    - [Case 1: Частичное восстановление файла](#case-1-частичное-восстановление-файла)
  - [Требует доработки](#требует-доработки)
    - [Case 2: Мгновенный откат всей системы (rollback)](#case-2-мгновенный-откат-всей-системы-rollback)
    - [Case 3: Полный откат через GRUB](#case-3-полный-откат-через-grub)

## Краткая теория
**B-Tree File System, Btrfs** (Файловая система на основе B-деревьев) имеет встроенную поддержку снимков (snapshots) на уровне файловой системы. Снимки создаются мгновенно и занимают место только по мере изменения данных (Copy-on-Write).

В Btrfs диск не делится на разделы в привычном смысле. Он делится на **субтома**.
-   `@` (или `root`) — корень системы (`/`).
-   `@home` — домашняя директория (`/home`).

Снимок — это тоже субтом. Когда делают снимок `@` (корня системы), создается новый субтом, который сначала является точной копией `@`. Лучшией практикой хранения снимков считается **в отдельном субтоме верхнего уровня**, `@snapshots` монтируется в `/.snapshots`.

Понятие снепшотов можно услышать в контексте виртуальных машин, развернутых в VirtualBox или VMWare, например. В подобных гипервизорах снимок — это полная копия состояния виртуальной машины, который занимает много места. В Btrfs снимок — это **моментальный "слепок"** файловой системы. Он занимает мало места в момент создания, хранит только изменения с момента создания и его можно монтировать как обычную папку для того, чтобы смотреть/копировать оттуда файлы.

Для управления снимками используют команды:
1. `btrfs subvolume snapshot` — ручной метод.
2. `snapper` — стандарт индустрии; утилита для автоматизации процессов (делать снимки до/после pacman, чистить старые).

## Настройка

Я хочу хранить снимки состояния корня и домашней директории, поэтому итоговая архитектура системы будет выглядеть следующим образом:
- `@` -> монтируется в `/`
- `@home` -> монтируется в `/home`
- `@snapshots` -> монтируется в `/.snapshots`
- `@snapshots-home` -> монтируется в `/home/.snapshots`

### Подготовка субтомов

Snapper не умеет создавать субтома на верхнего уровня, он делает их внутри текущего раздела. Поэтому делаем это вручную через временную точку монтирования.

1. Создаем папку: `sudo mkdir -p /mnt/btrfs-root`
2. С помощью команды `lsblk -f` нужно узнать UUID раздела Btrfs.
3. Монтируем корень диска:
- `sudo mount -o subvolid=5 UUID=bcd849c8-c2eb-48e1-81d4-89ca4ac9e2a1 /mnt/btrfs-root`
4. Делаем субтом для снимков корня:
- `sudo btrfs subvolume create /mnt/btrfs-root/@snapshots`
5. Делаем субтом для снимков домашней директории:
- `sudo btrfs subvolume create /mnt/btrfs-root/@snapshots-home`
6. Удаляем временную точку:
- `sudo umount /mnt/btrfs-root`
- `sudo rmdir /mnt/btrfs-root`

### Настройка `/etc/fstab`

**FSTAB**, File System Table (Таблица файловых систем) — конфигурационный файл, который говорит ядру Linux: «Какие диски (или их части) нужно подключить (смонтировать) при загрузке системы и куда именно их поместить в дереве папок». В строчке указывается UUID устройства, точка монтирования, тип файловой системы, опции монтирования, дамп для резервного копирования через `dump`, проверка порядка для проверки целостности файловой системы через `fsck`.

В конце файла добавляем следующие строчки:
``` bash
UUID=bcd849c8-c2eb-48e1-81d4-89ca4ac9e2a1  /.snapshots       btrfs  subvol=@snapshots,defaults,noatime,space_cache=v2       0 0

UUID=bcd849c8-c2eb-48e1-81d4-89ca4ac9e2a1  /home/.snapshots  btrfs  subvol=@snapshots-home,defaults,noatime,space_cache=v2  0 0
```

### Установка утилит

Потребуются следующие утилиты: основной демон `snapper`, `snap-pac` автоматически делает снимок до и после каждой установки/удаления пакетов через `pacman`, `grub-btrfs` позволяет выбирать снимки прямо в меню GRUB при загрузке.

```bash
sudo pacman -S snapper snap-pac grub-btrfs
```

### Инициализация конфига для root и home

1. Создаем конфиг (Snapper создаст свою вложенную папку .snapshots):
- `sudo snapper -c root create-config /`
2. Сразу размонтируем и удаляем это:
- `sudo umount /.snapshots 2>/dev/null`
- `sudo btrfs subvolume delete /.snapshots`
3. Создаем чистую точку монтирования и привязываем наш правильный субтом:
- `sudo mkdir /.snapshots; sudo mount -a`
4. Исправляем права:
- `sudo chown root:root /.snapshots`
- `sudo chmod 750 /.snapshots`

Повторяем ту же логику для домашней директории:
``` bash
sudo snapper -c home create-config /home
sudo btrfs subvolume delete /home/.snapshots
sudo mkdir /home/.snapshots
sudo mount -a
sudo chown :root /home/.snapshots
sudo chmod 750 /home/.snapshots
```

### Изменение конфигурации

Файлы конфигурации лежат в папке `/etc/snapper/configs/`.Что я изменила:
- `NUMBER_LIMIT="5"` снизила количество хранимых снимков pacman;
- `TIMELINE_CREATE="no"` убрала автоматическое создание снимков каждый час;
- `TIMELINE_LIMIT_...="0"` гарантирует, что "хвосты" от старых автоматических снимков не будут копиться.

### Автоматизация

**1 Квоты и Профилактика**

Включение квот позволит Snapper определять размер снимков и проводить очистку по месту.
``` bash
sudo btrfs quota enable /
sudo btrfs quota enable /home
```

Еженедельный Scrub является проверкой целостности данных (битых блоков) по контрольным суммам.
``` bash
sudo systemctl enable --now btrfs-scrub@-.timer
sudo systemctl enable --now btrfs-scrub@home.timer
```

Оптимизация SSD (TRIM) гарантирует, что удаленные данные в снимках действительно освобождают ячейки памяти.
``` bash
sudo systemctl enable --now fstrim.timer
```

**2 Автоматизация снимков Pacman**

`snap-pac` работает автоматически. Он создает пару снимков: `pre` (до) и `post` (после) установки утилит через `pacman`.
- Как только установишь любой пакет: `sudo pacman -S cmatrix`;
- Можно увидеть снимки: `snapper -c root list`.

**3 Интеграция с GRUB**

Чтобы GRUB не перезаписывал конфиг дважды за одну установку (на `pre` и `post` снимках), настроим демона с задержкой. Это важно для оптимизации записи на SSD.
- Редактируем сервис: `sudo systemctl edit grub-btrfsd.service`
``` bash
[Service]
ExecStart=
ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto --delay 15 /.snapshots
```

- Снимки домашней директории не пойдут в GRUB. Далее активируем:
``` bash
sudo systemctl enable --now grub-btrfsd
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**4 Настройка автоматической очистки**

- Включаем таймер автоматической очистки:
``` bash
sudo systemctl enable --now snapper-cleanup.timer
```

- Перед какими либо экспериментами можно создать снимок вручную и в описании оставить пометку "STABLE". В Snapper такие снимки имеют приоритет и реже попадают под "чистку" по количеству. Пример подобной команды:
``` bash
sudo snapper -c root create -d "STABLE: Before complex experiments" -u "important=true"
```

**5 Права доступа**

- Также стоит настроить, что только root может редактировать правила Snapper:
``` bash
sudo chmod 600 /etc/snapper/configs/*
```

## Основные команды

### Ручное управление
- `sudo btrfs filesystem usage /` : посмотреть свободное пространство.
- `sudo btrfs filesystem du -s /.snapshots/` : посмотреть сколько занято снимками.
- `sudo btrfs subvolume snapshot -r / /.snapshots/my-snapshot` : создать снимок вручную.
- `sudo btrfs subvolume delete /.snapshots/my-snapshot` : удалить снимок.

### Команды Snapper
- `sudo snapper list -a` : посмотреть список всех снимков с подробностями
- `sudo snapper -c root list` : посмотреть снимки root.
- `sudo snapper -c root create --description "test"` : создать снимок `root`.
- `sudo snapper -c root delete <ID>` : удалить конкретный снимок.
- `sudo snapper cleanup number` : очистить все старые снимки по правилам из конфига.
- `sudo snapper status 1..0` : сравнить два любых снимка.
- `sudo snapper diff 1 /etc/pacman.conf` : посмотреть различия в конкретном файле.
- Восстановить отдельный файл из снимка:
```bash
# Скопировать файл /etc/fstab из снимка #3
sudo snapper mount 3
sudo cp /mnt/.snapshots/3/snapshot/etc/fstab /etc/fstab
sudo umount /mnt/.snapshots/3
```

- Создать пару PRE/POST снимков (как snap-pac):
```bash
sudo snapper create --type pre --print-number --description "Обновление ядра"
sudo pacman -S linux
sudo snapper create --type post --pre-number 10 --description "Обновление ядра"
```

## Troubleshooting

### Case 0: Практика команд
1. Создай ручной снимок: `sudo snapper create --description "before txt file"`
2. Создай тестовый файл: `echo "Text" > /test.txt`
3. Создай второй снимок: `sudo snapper create --description "after txt file"`
4. Посмотри список снимков: `sudo snapper list -a`
5. Посмотри разницу: `sudo snapper status 20..21`
6. Удали файл: `sudo rm /test.txt`
7. Восстанови из снимка: 
``` bash
sudo snapper mount 21
sudo cp /mnt/.snapshots/21/snapshot/test.txt .
sudo umount /mnt/.snapshots/21
```
8. Проверь, что файл появился: `ls /test.txt`
9. Очисти тестовые снимки: `sudo snapper delete 20 21`

### Case 1: Частичное восстановление файла
1. Найди нужный файл в папке снимков: `ls /home/.snapshots/<номер>/snapshot/`
2. Просто скопируй его обратно: `cp /home/.snapshots/X/snapshot/user/file ~/file`

## Требует доработки

### Case 2: Мгновенный откат всей системы (rollback)
1. Найди рабочий снимок (например, #3): `sudo snapper list`
2. Создай новый снимок "текущего сломанного состояния": `sudo snapper create --description "something's wrong"`
3. Откатись к рабочему снимку: `sudo snapper rollback 3`
4. Перезагрузись: `sudo reboot`

### Case 3: Полный откат через GRUB
1. В меню GRUB выбери **Arch Linux Snapshots**.
2. Выбери последний рабочий снимок (`pre-pacman`).
3. Если система загрузилась, сделай этот откат постоянным: `sudo snapper -c root rollback`
   - Есть утилита `snapper-rollback` из AUR.
4. Обновить конфигурацию: `sudo grub-mkconfig -o /efi/grub/grub.cfg`
5. Перезагрузись: `sudo reboot`