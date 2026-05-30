# Python для OSINT
- [Python для OSINT](#python-для-osint)
  - [Поиск, скрапинг и OSINT-инструменты](#поиск-скрапинг-и-osint-инструменты)
    - [Поиск по никнейму](#поиск-по-никнейму)
    - [Сбор поисковых выдач](#сбор-поисковых-выдач)
    - [Пример: DuckDuckGo Search (`DDGS`)](#пример-duckduckgo-search-ddgs)
  - [HTTP-запросы, API и прокси](#http-запросы-api-и-прокси)
    - [Базовый скрапинг (`requests` + `BeautifulSoup`)](#базовый-скрапинг-requests--beautifulsoup)
    - [Прокси и User-Agent](#прокси-и-user-agent)
    - [Тестирование API](#тестирование-api)
  - [Регулярные выражения, WHOIS \& DNS](#регулярные-выражения-whois--dns)
    - [Regex в Python](#regex-в-python)
    - [WHOIS \& DNS](#whois--dns)
    - [Поиск поддоменов](#поиск-поддоменов)
  - [Архивы, генерация документов и визуализация](#архивы-генерация-документов-и-визуализация)
    - [Wayback Machine](#wayback-machine)
    - [Генерация отчётов](#генерация-отчётов)
    - [Визуализация данных](#визуализация-данных)
  - [Установка и запуск инструментов](#установка-и-запуск-инструментов)
    - [PyPI \& GitHub](#pypi--github)
    - [Запуск внешних скриптов из Python](#запуск-внешних-скриптов-из-python)

**OSINT** (Open Source Intelligence) — разведка по открытым источникам. Используется для сбора и анализа публично доступной информации (соцсети, реестры, утечки, новости) без взлома или нелегальных действий. Позволяет выявлять утечки данных компании, находить фишинговые ресурсы, проверять контрагентов и сотрудников, а также оценивать цифровой след организации до того, как им воспользуются злоумышленники.

## Поиск, скрапинг и OSINT-инструменты
Базовый этап цифровой разведки: автоматизация поиска упоминаний, извлечение структурированных данных с веб-страниц и использование специализированных утилит для быстрого сбора публичной информации без ручного перебора.
### Поиск по никнейму
Проверка наличия одного username на сотнях сайтов для выявления цифрового следа, связывания аккаунтов и построения профиля цели.
- [Sherlock](https://github.com/sherlock-project/sherlock);
- [Maigret](https://github.com/soxoj/maigret);
- [thorndyke](https://github.com/rly0nheart/thorndyke);
- [blackbird](https://github.com/p1ngul1n0/blackbird).

### Сбор поисковых выдач
Агрегация результатов из поисковых систем без браузера. Позволяет быстро собирать email, ссылки и сниппеты по заданным ключевым словам, обходя ограничения и капчу веб-интерфейсов.
- **EmailFinder** – поиск email через Google/Bing/Baidu
- **StartPageParser** – парсинг Google
- **Searcher** – Ask, Bing, Brave, DuckDuckGo, Yahoo, Yandex
- **DDGR** – DuckDuckGo CLI
- **SearchEnginesScraper** – 11 поисковиков

### Пример: DuckDuckGo Search (`DDGS`)
Использование библиотеки `duckduckgo_search` для программного получения результатов поиска без регистрации API-ключей. Результаты сразу сохраняются в структурированном формате (CSV) для дальнейшей фильтрации.

```python
from duckduckgo_search import DDGS
import csv

keywords = 'osint'
results = DDGS().text(keywords, region='us-en', safesearch='Off', max_results=5)

with open('search_results.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f, delimiter=';')
    for r in results:
        writer.writerow([r["title"], r["body"], r["href"]])
```
Подробнее: [duckduckgo-search docs](https://pypi.org/project/duckduckgo-search/)

---

## HTTP-запросы, API и прокси
Фундамент веб-скрапинга: отправка запросов к серверам, обработка ответов, управление сессиями и обход базовых защит с помощью заголовков и прокси. Понимание HTTP-методов и статус-кодов обязательно для стабильной работы скриптов.

### Базовый скрапинг (`requests` + `BeautifulSoup`)
Классический стек для извлечения данных: `requests` загружает HTML-страницу, а `BeautifulSoup` парсит DOM-дерево, позволяя находить и извлекать нужные элементы по тегам, атрибутам или CSS-классам.

```python
import requests
from bs4 import BeautifulSoup

url = "https://pypi.org/project/duckduckgo-search/"
resp = requests.get(url)
soup = BeautifulSoup(resp.content, "html.parser")

title = soup.find("title").get_text()
print(title)
```

### Прокси и User-Agent
Методы анонимизации и имитации реального браузера. Прокси скрывают реальный IP-адрес, а User-Agent подменяет информацию о клиенте, снижая риск блокировки скрипта антибот-системами.

```python
proxies = {'https': '135.181.149.47:8080'}
headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}

resp = requests.get('https://www.whatismybrowser.com/', proxies=proxies, headers=headers)
print(resp.text)
```

**Источники прокси:**
- [hidemy.name](https://hidemy.name/en/),
- [Proxy-List GitHub](https://github.com/clarketm/proxy-list).

**Инструменты:**
- `mitmproxy`,
- `Proxify`,
- `XX-Net`.

### Тестирование API
Подготовка к автоматизации: проверка эндпоинтов, методов аутентификации и форматов ответов перед написанием кода. Позволяет избежать ошибок валидации и лишних запросов к целевым сервисам.
- [reqbin](https://reqbin.com/)
- REST API Tester (Postman, Insomnia)

---
## Регулярные выражения, WHOIS & DNS
Анализ структуры данных и сетевой инфраструктуры: поиск строгих паттернов в текстах, получение регистрации доменов и разрешение DNS-записей для выявления связанных ресурсов.

### Regex в Python
Мощный инструмент для поиска и извлечения паттернов (email, телефоны, хэши, ID) из неструктурированных текстов и файлов без использования тяжёлых парсеров.

```python
import re, glob, os

os.chdir("Day_14/test_dir")
email_pattern = re.compile(r'[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+')

for f in glob.glob("*"):
    with open(f, encoding='utf-8') as file:
        content = file.read()
        if email_pattern.search(content):
            print(f"Emails found in: {f}")
```

Подробнее: [Regex для OSINT](https://medium.com/@cyb_detective/this-article-consists-of-three-short-parts-31d31efabd5).

### WHOIS & DNS
Получение административных данных о домене (владелец, регистратор, даты создания/истечения) и сопоставление доменных имён с IP-адресами через DNS-запросы для анализа инфраструктуры.

Установка:
```bash
pip install python-whois dnspython discosub
```

Пример:
```python
import whois, dns.resolver

# WHOIS
info = whois.whois('google.com')
print("Created:", info.creation_date[0] if isinstance(info.creation_date, list) else info.creation_date)

# DNS (A-записи)
for ip in dns.resolver.resolve('google.com', 'A'):
    print("IP:", ip.to_text())
```

### Поиск поддоменов
Выявление скрытых или забытых узлов инфраструктуры целевого домена. Поддомены часто содержат тестовые среды, панели администратора или уязвимые сервисы, не указанные на основном сайте.

```bash
discosub run nytimes.com > nytimes_subdomains.txt
```

---
## Архивы, генерация документов и визуализация
Финальные этапы OSINT: работа с историческими данными, автоматизация оформления отчётов и преобразование сырых данных в наглядные графики или интерактивные дашборды для анализа и презентации.

### Wayback Machine
Цифровой архив интернета, позволяющий просматривать удалённые или изменённые веб-страницы, отслеживать эволюцию контента, находить утерянные контакты и фиксировать изменения в профилях.
- [archive.org](https://archive.org/) – поиск удалённых страниц, изменений в профилях, утерянных контактов.

### Генерация отчётов
Автоматизация документирования результатов: создание Excel, Word, PDF и PowerPoint файлов прямо из Python, а также развёртывание интерактивных веб-интерфейсов через Streamlit без знания фронтенда.

Установка:
```bash
pip install XlsxWriter python-docx fpdf python-pptx streamlit
```

Инструменты:
- `XlsxWriter` / `python-docx` – Excel & Word
- `fpdf` – PDF-отчёты
- `python-pptx` – Презентации
- `streamlit` – Быстрые веб-дашборды без HTML/JS

### Визуализация данных
Преобразование табличных или геопространственных данных в графики, диаграммы и карты для быстрого анализа закономерностей, кластеризации связей и наглядной подачи результатов.

Установка:
```bash
pip install matplotlib numpy basemap
```

Инструменты:
- `matplotlib` + `numpy` – графики, массивы
- `basemap` / `cartopy` – картографические данные

---
## Установка и запуск инструментов
### PyPI & GitHub
Стандартные способы установки Python-пакетов: через официальный репозиторий PyPI для стабильных модулей или клонирование репозиториев с GitHub для свежих/нестандартных версий и ручных сборок.

```bash
# Стандартная установка
pip install thorndyke

# Клонирование репозитория
git clone https://github.com/p1ngul1n0/blackbird
cd blackbird
pip install -r requirements.txt
```

### Запуск внешних скриптов из Python
Позволяет комбинировать готовые инструменты с кастомной логикой обработки данных, не переписывая их на Python.
```python
import subprocess
subprocess.call("python blackbird.py -u ivanov", shell=True)
```