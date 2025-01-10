FROM fuzz-base-builder

RUN apt update 
RUN apt install -yy cmake clang
RUN apt install -yy git protobuf-compiler libprotobuf-dev binutils ninja-build liblzma-dev libz-dev pkg-config autoconf libtool
RUN apt install -yy gdb
RUN apt install -yy python3-dev
RUN apt install -yy libpcre3 libpcre3-dev # for nginx
RUN apt install -yy libc6
RUN update-alternatives --set cc /usr/bin/clang

RUN git config --system --replace-all safe.directory '*'

ENV IS_DOCKER=1

WORKDIR /src