SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

docker stop riscv_toolchain
docker rm riscv_toolchain
docker run --name riscv_toolchain -it \
	-v $SCRIPTPATH/../:/zkGeth \
	-d zkgeth/riscv_toolchain /bin/bash

