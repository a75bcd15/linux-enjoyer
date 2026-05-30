# Продолжение Python
- [Продолжение Python](#продолжение-python)
  - [Модули и библиотеки](#модули-и-библиотеки)
    - [Встроенные и стандартные](#встроенные-и-стандартные)
    - [`random`](#random)
    - [`statistics`](#statistics)
    - [`pandas` / `numpy`](#pandas--numpy)
    - [`math`](#math)
  - [Работа с файлами и файловой системой](#работа-с-файлами-и-файловой-системой)
    - [Чтение и запись](#чтение-и-запись)
    - [Поиск файлов через `glob` и `os`](#поиск-файлов-через-glob-и-os)
  - [Форматы данных: JSON \& CSV](#форматы-данных-json--csv)
    - [JSON](#json)
    - [CSV: Создание и чтение](#csv-создание-и-чтение)
    - [Конвертация API JSON → CSV](#конвертация-api-json--csv)
- [virtual environment (venv)](#virtual-environment-venv)

## Модули и библиотеки
### Встроенные и стандартные
```python
import sys
sys.argv          # Аргументы командной строки
sys.path          # PYTHONPATH
if __name__ == '__main__':
    print('Запущено самостоятельно')
```

### `random`

| Функция | Описание |
|---------|----------|
| `randint(a, b)` | Целое число в `[a, b]` (возможны повторы) |
| `randrange(start, stop, step)` | Работает как `range()` |
| `random()` | Вещественное в `[0.0, 1.0)` |
| `uniform(a, b)` | Вещественное в `[a, b]` |
| `seed(n)` | Фиксация начального значения генератора |
| `shuffle(list)` | Перемешивание списка на месте |
| `choice(seq)` | Один случайный элемент |
| `sample(seq, k)` | `k` уникальных случайных элементов |

### `statistics`

| Функция | Описание |
|---------|----------|
| `mode()` | Наиболее часто встречающееся значение (мода) |
| `multimode()` | Список всех наиболее часто встречающихся значений |
| `median()` | Медиана (среднее значение в отсортированном ряду) |
| `median_low()` | Нижняя медиана (меньшее из двух средних значений) |
| `median_high()` | Вверхняя медиана (большее из двух средних значений) |
| `median_grouped()` | Медиана сгруппированных данных (интерполированную) |
| `mean()` | Среднее арифметическое значение |
| `fmean()` | Быстрое вычисление среднего арифметического для чисел с плавающей точкой |
| `harmonic_mean()` | Среднее гармоническое значение |
| `geometric_mean()` | Среднее геометрическое значение |

[Ссылка](https://docs.python.org/3/library/statistics.html) на документацию.
### `pandas` / `numpy`

```python
import pandas as pd
df = pd.read_csv("dataset.csv")
pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
df.sort_values(by=['sex','age'], ascending=[True, True])
```

Ссылка на документацию [pandas](https://pandas.pydata.org/docs/reference/index.html#api) и [numpy](https://numpy.org/doc/stable/reference/index.html#reference).
### `math`

| Функция | Описание |
|---------|----------|
| `asin()` | Арксинус числа (в радианах) |
| `cos()` | Косинус угла (в радианах) |
| `sqrt()` | Квадратный корень числа |
| `pi` | Математическая константа π (≈ 3.14159...) |

---

## Работа с файлами и файловой системой
### Чтение и запись
```python
# Запись (режимы: "r" чтение, "w" перезапись, "a" добавление, "x" создание)
with open("results.txt", "a", encoding="utf-8") as f:
    f.write("Results text\n")

# Способ 1: Чтение всего файла
with open("results.txt", "r") as f:
    print(f.read())

# Способ 2: Построчное чтение с нумерацией
with open("results.txt", "r") as f:
    for i, line in enumerate(f, 1):
        print(f"{i}. {line.strip()}")

# Способ 3: Чтение в список и доступ по индексу
with open("results.txt", "r") as f:
    lines = f.readlines()
    print(lines[1].strip())
```

### Поиск файлов через `glob` и `os`
```python
import glob, os

os.chdir("Day_14/test_dir")

# Поиск по расширению
print("TXT files:")
for f in glob.glob("*.txt"):
    print(f)

# Чтение содержимого всех .txt
for f in glob.glob("*.txt"):
    with open(f, encoding="utf-8") as file:
        print(file.read())

# Поиск строки/символа в файлах
for f in glob.glob("*"):
    with open(f, encoding="utf-8") as file:
        content = file.read()
        if "2" in content:
            print(f"Found in: {f}\n{content}")
```
---

## Форматы данных: JSON & CSV

### JSON
- Структура `ключ: значение`. Удобно для API.
- Анализ/визуализация: [jsonpath](https://jsonpath.com/), [csvjson](https://csvjson.com/)

### CSV: Создание и чтение
```python
import csv

# Запись
with open('test.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f, delimiter=';')
    writer.writerow(['Last name', 'First name', 'Age', 'Country'])
    writer.writerow(['Smith', 'John', '35', 'USA'])

# Чтение
with open("test.csv", 'r', encoding='utf-8') as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)
```

### Конвертация API JSON → CSV
```python
import requests, csv

res = requests.get("https://api.github.com/search/users?q=javascript")
data = res.json()

with open('github_users.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f, delimiter=';')
    for item in data['items'][:5]:  # Ограничим 5 результатами
        writer.writerow([item['login'], item['html_url'], item['avatar_url']])
```
---

# virtual environment (venv)
**Python virtual environment (venv)** — это изолированная директория, содержащая собственную копию интерпретатора Python и библиотеки. Все программы используют одни и те же системные библиотеки. Если программа А требует библиотеку версии 1.0, а программа Б — версию 2.0, возникнет конфликт. Без venv обновление для одной сломает другую.

В Arch Linux категорически нельзя устанавливать пакеты через `pip install` глобально. Это может обновить системные библиотеки до несовместимых версий и сломать ОС. `venv` гарантирует, что зависимости пет-проекта останутся внутри папки проекта и не затронут систему.

Установка:
``` bash
sudo pacman -S python-virtualenv
python -m venv --help
```

Далее внутри проекта создаётся окружение в папке `venv`:
``` bash
python -m venv venv
```
Запуск окружения:
``` bash
source venv/bin/activate
```
Выход из окружения:
``` bash
deactivate
```