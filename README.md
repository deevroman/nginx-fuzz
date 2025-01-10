# Адаптированный под arm64 фаззер парсера HTTP-заголовков в nginx
 
Основано на проекте OSS-Fuzz с адаптацией под arm64 и фаззинг nginx.

## Инструкция

### Клонируем репозиторий

```
git clone --recurse-submodules git@github.com:deevroman/nginx-fuzz.git
```

### Сборка образов

Для запуска нужно собрать базовые docker-образы с необходимыми тулчейнами. 
Для x86 можно воспрользоваться образами от OSS-fuzz:

```sh
make pull-x86-base-builder build-fuzz-image-x86
```

Но если у вас arm64... либо запасайтесь терпением и собирайте:

```sh
make build-base-images build-fuzz-image
```

Либо используйте уже собранные:

```sh
make pull-base-builder build-fuzz-image
```

На выходе получаем образ `fuzz-base-builder` (базовый образ) и `fuzz_arm` (конкретно для фаззинга nginx).

### Сборка libprotobuf-mutator

```sh
make setup-protobuf-mutator
```

В проекте должна появиться директории LPM. 

### Сборка nginx

Запускаем сборку nginx c libfuzzer'ом. 

```sh
make build-in-docker
```

В директории out появятся бинарь фаззера, который можно запустить. 

### Запуск

Можно также сразу собрать и запустить фаззинг:

```sh
make clean-fuzz run-fuzz
```

В файле `fuzz/http_request_fuzzer.cc` допущена редкостреляющая ошибка. Запуск фаззера должен довольно быстро её найти.

### TODO

- [ ] Инструкция под x86
- [ ] Расширить генератор данных