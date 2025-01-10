# nginx fuzzing with libprotobuf-mutator for arm64

Адаптированный под arm64 фаззер парсера HTTP-заголовков в nginx. Основано на проекте OSS-Fuzz с адаптацией под arm64 и фаззинг nginx

Для запуска понадобиться собрать базовые docker-образы с необходмыми тулчейнами. OSS-Fuzz предоставляет только под x86, поэтому запасаемся терпением и собираем:

```sh
    make build-base-images build-fuzz-image
```

На выходе получаем `fuzz-base-builder` (основа) и `fuzz_arm` (конкретно для фаззинга nginx). Настраиванием `libprotobuf-mutator` 

```sh
    make prepare
```

В проекте должна появится директории LPM. После этого запускаем сборку nginx c libfuzzer'ом. 

```sh
  make build-in-docker
```

В директории out появятся бинарь фаззера, который можно запустить. Сразу собрать и запустить фаззинг можно так

```sh
    make clean-fuzz run-fuzz
```