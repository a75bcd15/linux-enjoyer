# Делаем ОС с выходом в Интернет
На самом деле ноутбук с браузером покрывает >80% моих потребностей, поэтому первым делом лучше поставить себе такую тривиальную задачу. 

- [Делаем ОС с выходом в Интернет](#делаем-ос-с-выходом-в-интернет)
  - [Установка образа на флешку](#установка-образа-на-флешку)
    - [Шаг 1. Скачиваем необходимые файлы](#шаг-1-скачиваем-необходимые-файлы)
    - [Шаг 2. Проверяем ISO образ](#шаг-2-проверяем-iso-образ)
    - [Шаг 3. Утилита dd](#шаг-3-утилита-dd)
  - [Archinstall](#archinstall)
    - [Параметры](#параметры)
  - [Рабочий стол](#рабочий-стол)
    - [Русская раскладка](#русская-раскладка)
    - [Пасхалка](#пасхалка)

## Установка образа на флешку
У меня стояла Fedora, поэтому процесс установки ISO образа на флешку я выполняла в командной строке. 

### Шаг 1. Скачиваем необходимые файлы
С [официального сайта](https://archlinux.org/download/) перешла на зеркала и скачала:
- `archlinux-2026.05.01-x86_64.iso` — сам установочный образ (основной файл);
- `b2sums.txt` — текстовый файл с контрольными суммами для проверки целостности;
- `archlinux-2026.05.01-x86_64.iso.sig` — файл цифровой подписи для проверки подлинности.

Можно сразу записать ISO на флешку и запустить установку, но это небезопасно. Без проверочных файлов не определить, если ISO скачался с ошибкой или был взломан.

### Шаг 2. Проверяем ISO образ
Инструкция лежит на официальном сайте. Теперь немного пояснений.

``` bash
b2sum -c b2sums.txt
```

- `b2sum` — это утилита для вычисления хэш-функции BLAKE2b;
- `-c b2sums.txt` дает команду прочитать файл со списком правильных хэшей;
- Программа заново рассчитывает хэш ISO-файла и сравнивает его со значением в текстовом файле. Совпадение хэшей гарантирует отсутствие повреждений в файле.

``` bash
sq network wkd search pierre@archlinux.org --output release-key.pgp
```

- **Sequoia** — это современный инструмент для работы с OpenPGP;
- `network wkd search` ищет ключ разработчика в сети по протоколу WKD (Web Key Directory) на официальном домене (archlinux.org);
- `--output` сохраняет найденный публичный ключ в файл `release-key.pgp`.

``` bash
sq verify --signer-file release-key.pgp --signature-file archlinux-2026.05.01-x86_64.iso.sig archlinux-2026.05.01-x86_64.iso
```

- `sq verify` запускает процесс проверки цифровой подписи владельца этого ключа;
- `--signer-file` указывает на полученный ранее ключ разработчика;
- `--signature-file` указывает на файл подписи (.sig).

> Возможный вывод команды sq:
> ```
> Signing key on 3E80CA1A8B89F69CBA57D98A76A5EF9054449A5C is not bound:
>
>  Error: Policy rejected asymmetric algorithm
>because: EdDSA is not considered secure
>0 authenticated signatures, 1 bad key.
>
>  Error: Verification failed: could not authenticate any signatures
>```
> Разработчик Arch Linux (Pierre Schmitz) использовал современный и быстрый алгоритм EdDSA для создания своей цифровой подписи. Однако утилита sq на моем компьютере скомпилирована или настроена с жесткой политикой безопасности (Crypto Policy), которая по какой-то причине считает этот алгоритм небезопасным или неизвестным. Проверка не удалась из-за внутренних ограничений самой утилиты.

``` bash
gpg --auto-key-locate clear,wkd -v --locate-external-key pierre@archlinux.org
```

- **GnuPG** — это классическая программа для шифрования и подписей;
- `--auto-key-locate clear,wkd` настраивает поиск ключа через протокол WKD;
- `-v` включает подробный вывод информации на экран;
- `--locate-external-key` запрашивает импорт ключа для указанного email.

``` bash
gpg --verify archlinux-2026.05.01-x86_64.iso.sig archlinux-2026.05.01-x86_64.iso
```

- `--verify` сопоставляет файл подписи (.sig) и сам ISO-файл.

> Возможный вывод команды gpg:
> ```
> gpg: Signature made Fri 01 May 2026 12:07:18 PM +06
>gpg:                using EDDSA key 3E80CA1A8B89F69CBA57D98A76A5EF9054449A5C
>gpg:                issuer "pierre@archlinux.org"
>gpg: Good signature from "Pierre Schmitz <pierre@archlinux.org>" [unknown]
>gpg: WARNING: The key's User ID is not certified with a trusted signature!
>gpg:          There is no indication that the signature belongs to the owner.
>Primary key fingerprint: 3E80 CA1A 8B89 F69C BA57  D98A 76A5 EF90 5444 9A5C
>```
> - Good signature: Это означает, что проверка прошла успешно. Файл ISO подлинный, он действительно был подписан разработчиком Pierre Schmitz, и файл не изменялся злоумышленниками.
> - WARNING: ... not certified: Это стандартное предупреждение GPG. Оно означает лишь то, что лично я (мой ПК) никогда раньше не встречалась с Пьером Шмитцем и не помечала его ключ в своей системе как «абсолютно доверенный». Это нормальное поведение при первой проверке.

### Шаг 3. Утилита dd
Предварительно нужно вывести список всех дисков `lsblk`, подключить USB-флешку к компьютеру, снова выполнить команду `lsblk` и найти появившееся устройство (например, sdb или sdc). Флешка должна быть отключена от системы (`sudo umount /dev/sdb*`). 

``` bash
sudo dd if=/путь/к/файлу.iso of=/dev/sdb bs=4M status=progress oflag=sync
```

- `if=` — путь к ISO-файлу;
- `of=` — путь к целевой флешке;
- `bs=4M` — скорость чтения и записи по 4 Мегабайта;
- `status=progress` — показ процесса копирования;
- `oflag=sync` — принудительное завершение записи перед выходом.

> Возможный вывод команды dd:
> ```
> 1543503872 bytes (1.5 GB, 1.4 GiB) copied, 215 s, 7.2 MB/s 
> 368+1 records in
> 368+1 records out
> 1545814016 bytes (1.5 GB, 1.4 GiB) copied, 215.556 s, 7.2 MB/s
> ```

Проверить, что всё прошло успешно можно с помощью `cmp`. Утилита покажет битые ячейки памяти. Вместо `-n 1545814016` нужно подставить своё значение из вывода команды `dd`.
``` bash
cmp -n 1545814016 путь/к/file.iso /dev/sdb
```

## Archinstall
В первый раз не стала заморачиваться и всё делала через `archinstall` по ролику [на ютубе](https://www.youtube.com/watch?v=iykD_ELku7g). Предварительно я подключила ноутбук к своей Wi-Fi сети с помощью `iwctl`:
1. `iwctl` заходим в утилиту;
2. `device list` смотрим список интерфейсов;
3. `station wlan0 scan` сканируем сети;
4. `station wlan0 get-networks` смотрим список доступных сетей;
5. `station wlan0 connect my_network` выбираем нашу и вводим пароль;
6. `quit` выходим из утилиты;
7. `ping -с 3 google.com` проверяем подключение к интернету.

### Параметры
- Archinstall language
- Locales
    - Keyboard layout: us
    - Locale language: en_US.UTF-8
    - Locale encoding: UTF-8
- Mirrors and repositories
    - Russia
    - multilib
- Disk configuration
    - Configuration type: Use a best-effort default partition layout
- Swap
    - Swap on zram: Enabled
    - Compression algorithm: zstd
- Bootloader
    - Bootloader: GRUB
    - UKI: Disabled
    - Removable: Disabled
- Kernels
    - Kernel: linux
- Hostname
- Authentication
- Profile
    - Hyprland
    - Graphics driver: All open-source
    - Greeter: ly
- Applications
    - Bluetooth: Enabled
    - Audio: pipewire
    - Additional fonts: (добавила все)
- Network configuration
    - Network configuration: Use Network Manager (default backend)
- Additional packages
- Timezone
- Automatic time sync (NTP)
    - NTP: Enabled

## Рабочий стол
После перезагрузки появится рабочий стол с предупреждением о том, что необходмо изменить конфигурацию Hyprland. Открыла терминал комбинацией `Super + Q`. Для своего удобства я первым делом хотела установить редактор кода, поэтому снова пришлось подключиться к Wi-Fi сети, но уже через другую утилиту.
1. `nmcli radio wifi on` включить Wi-Fi модуль;
2. `nmcli device wifi list` показать список сетей;
3. `nmcli device wifi rescan` обновить список;
4. `nmcli device wifi connect "my_network" password "qwerty"` подключиться к сети.

Установить редактор кода, браузер и гит:

``` bash
sudo pacman -S code firefox git less
```

Открывать программы можно через терминал соответствующими командами. В файле `~/.config/hypr/hyprland.conf` нужно закомментировать строчку `autogenerated = 1` и предупреждение пропадёт. В конфигурации есть ссылка на файл `hyprland.lua`. Я редактирую этот шаблон.

### Русская раскладка
Чтобы заработала русская раскладка, в конфиге `~/.config/hypr/hyprland.lua` изменила строчки:

``` lua
hl.config({
    input = {
        kb_layout  = "us,ru",
        kb_options = "grp:alt_shift_toggle",
        },
})
```

Сразу после сохранения должны примениться изменения, если этого не случилось можно воспользоваться командой:
``` bash
hyprctl reload
```

Ещё можно добавить выбор и вставку эмодзи.
1. Убедиться, что есть пакет, отображающий эмодзи: `pacman -Q noto-fonts-emoji`
2. Установить нужные пакеты: `sudo pacman -S rofimoji wtype`
3. В конфиге прописать сочетание клавиш (например, `SUPER + /`):
``` lua
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd("rofimoji --action type"))
```

### Пасхалка
Можно сделать так, что при обновлении или установке любых пакетов через терминал индикатор выполнения превратится в анимированного Пакмена, который ест точки. 
1. Отредактировать конфиг командой `sudo nano /etc/pacman.conf`;
2. Найти секцию `# Misc options`;
3. Раскомментировать строчку `#ILoveCandy` или добавить её вручную;
4. Сохранить и выйти из редактора.
