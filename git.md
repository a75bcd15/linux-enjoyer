# Git

## Моё пространство
Этот репозиторий имеет две ветки на моём компьютере. `main` является публичной, финальной версией моих конспектов. `develop` является приватной, в ней я храню черновики и наброски заметок. Для того, чтобы таким образом организовать пространство, нам потребуется иметь два репозитория на гитхабе, так как отдельно нельзя настроить ветки.

Рекомендую сгенерировать и добавить SSH ключ на GitHub для удобства авторизации. Далее на сайте GitHub создайте два репозитория, например, `linux-enjoyer` - публичный и `linux-enjoyer-develop` - приватный. Локально проходимся по следующим шагам:
1. `mkdir linux-enjoyer; cd linux-enjoyer` создаём репозиторий и переходим в него;
2. `git init` инициализируем репозиторий;
3. `git branch -M main` создаём основную ветку `main`, которая будет заливаться на публичный репо;
4. `touch README.md` создаём файл;
5. `git add README.md` делаем его отслеживаемым;
6. `git commit -m "init repo"` делаем коммит;
7. `git remote add origin git@github.com:user/linux-enjoyer.git` указываем публичный репозиторий под именем `origin` (**user** меняем на свой ник на гитхаб);
8. `git remote add origin-private git@github.com:user/linux-enjoyer-develop.git` указываем приватный репозиторий под именем `origin-private`;
9. `git branch` проверить на какой ветке находимся;
10. `git push -u origin main` отправить ветку `main` в публичный репозиторий `origin`;
11. `git switch -c develop` создаём и переключаемся на ветку `develop`, которая будет видна только нам;
12. `echo "# Черновики" > README.md` изменяем файл;
13. `git add README.md; git commit -m "init drafts"` фиксируем изменения;
14. `git push -u origin-private develop` отправляем ветку `develop` в приватный репозиторий `origin-private`;
15. `git branch -vv` проверить ветки.

Вывод команды `git branch -vv` представлен ниже. Тоже самое можно проверить на сайте GitHub. Теперь ветки будут пушиться в разные места, при этом их удобно локально сливать и следить за изменениями.
``` 
* develop 937429d [origin-private/develop] init drafts
  main    dde68a4 [origin/main] init repo
```
