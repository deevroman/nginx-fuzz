build-base-images:
	cd docker && docker build --platform linux/arm64 . -t fuzz-base-image -f base-image.yml
	cd docker && docker build --platform linux/arm64 . -t fuzz-base-clang -f base-clang.yml --build-arg arch=aarch64
	cd docker && docker build --platform linux/arm64 . -t fuzz-base-builder -f base-builder.yml

no-cache-build-fuzz-image:
	docker build --platform linux/arm64 . -t fuzz_arm --progress=plain --no-cache

build-fuzz-image:
	docker build --platform linux/arm64 . -t fuzz_arm --progress=plain

bash:
	docker start -i fuzz_sandbox

new-bash:
	docker rm fuzz_sandbox; docker run --name fuzz_sandbox -v .:/src -v out:/out -it -e FUZZING_LANGUAGE=c -e SANITIZER=address fuzz_arm:latest bash

prepare:
	(mkdir LPM && cd LPM && cmake ../libprotobuf-mutator -GNinja -DLIB_PROTO_MUTATOR_DOWNLOAD_PROTOBUF=ON -DLIB_PROTO_MUTATOR_TESTING=OFF -DCMAKE_BUILD_TYPE=Release && ninja)
	cd nginx && git apply ../add_fuzzers.diff

build:
	cd nginx && compile

build-in-docker:
	docker run --rm --name fuzz_build -v .:/src -v ./out:/out -e FUZZING_LANGUAGE=c -e SANITIZER=address fuzz_arm:latest bash -c "cd nginx && compile"

setup-protobuf-mutator:
	make prepare

clean-fuzz:
	docker rm fuzz_space

run-fuzz:
	docker run --name fuzz_space -v .:/src -v ./out:/out -it -e FUZZING_LANGUAGE=c -e SANITIZER=address fuzz_arm:latest bash -c "cd nginx && compile && /out/http_request_fuzzer"