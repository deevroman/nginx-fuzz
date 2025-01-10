# Адаптированный под arm64 фаззер парсера HTTP-заголовков в nginx
 
Основано на проекте OSS-Fuzz с адаптацией под arm64 и фаззинг nginx.

### Клонируем репозиторий

```
git clone --recurse-submodules git@github.com:deevroman/nginx-fuzz.git
```

### Сборка образов

Для запуска нужно собрать базовые docker-образы с необходимыми тулчейнами. OSS-Fuzz предоставляет только под x86, поэтому запасаемся терпением и собираем:

```sh
make build-base-images build-fuzz-image
```

На выходе получаем образ `fuzz-base-builder` (основа) и `fuzz_arm` (конкретно для фаззинга nginx).

### Сборка libprotobuf-mutator

```sh
make setup-protobuf-mutator
```

В проекте должна появится директории LPM. 

### Сборка

Запускаем сборку nginx c libfuzzer'ом. 

```sh
make build-in-docker
```

В директории out появятся бинарь фаззера, который можно запустить. 

### Запуска

Можно также сразу собрать и запустить фаззинг:

```sh
make clean-fuzz run-fuzz
```

В файле `fuzz/http_request_fuzzer.cc` допущена редкостреляющая ошибка. Запуск фаззера должен довольно быстро её найти.