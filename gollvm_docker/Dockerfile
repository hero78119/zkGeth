# syntax=docker/dockerfile:1.3-labs
# vim:syntax=dockerfile
FROM ubuntu:focal-20220826

# Set this before `apt-get` so that it can be done non-interactively
ENV DEBIAN_FRONTEND noninteractive
ENV TZ America/New_York
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

ADD docker/sources.list /etc/apt/

RUN /bin/sh -c set -xe 		&& echo '#!/bin/sh' > /usr/sbin/policy-rc.d 	&& echo 'exit 101' >> /usr/sbin/policy-rc.d 	&& chmod +x /usr/sbin/policy-rc.d 		&& dpkg-divert --local --rename --add /sbin/initctl 	&& cp -a /usr/sbin/policy-rc.d /sbin/initctl 	&& sed -i 's/^exit.*/exit 0/' /sbin/initctl 		&& echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup 		&& echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean 	&& echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean 	&& echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean 		&& echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages 		&& echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes 		&& echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggests

CMD ["/bin/bash"]

RUN apt update && apt install --no-install-recommends -y git ninja-build cmake build-essential clang autoconf ca-certificates python vim autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev && apt list --installed

RUN apt install python3 -y

RUN mkdir -p /gollvm/src /gollvm/build /gollvm/install

WORKDIR .

COPY ../riscv-gnu-toolchain /riscv-gnu-toolchain

RUN cd /riscv-gnu-toolchain && ./configure --prefix=/opt/riscv && make linux

COPY ../llvm-project /gollvm/src/llvm

COPY ../gollvm /gollvm/src/llvm/llvm/tools/gollvm

COPY ../gofrontend /gollvm/src/llvm/llvm/tools/gollvm/gofrontend

COPY ../libffi /gollvm/src/llvm/llvm/tools/gollvm/libgo/libffi

COPY ../libbacktrace /gollvm/src/llvm/llvm/tools/gollvm/libgo/libbacktrace


RUN cd /gollvm/build && cmake -DCMAKE_INSTALL_PREFIX=/gollvm/install -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGET_ARCH="X86-64,RISCV64" -DLLVM_TARGETS_TO_BUILD="X86;RISCV" -DGOLLVM_USE_SPLIT_STACK=OFF -DLLVM_USE_LINKER=gold -DCMAKE_CXX_STANDARD=20 -G Ninja /gollvm/src/llvm/llvm

RUN cd /gollvm/build && ninja gollvm

RUN cd /gollvm/build && ninja GoBackendCoreTests && tools/gollvm/unittests/BackendCore/GoBackendCoreTests

RUN cd /gollvm/build && ninja install-gollvm

RUN apt install -y vim

ENV LD_LIBRARY_PATH=/gollvm/install/lib64

ENV PATH="/opt/riscv/bin/:$PATH"
