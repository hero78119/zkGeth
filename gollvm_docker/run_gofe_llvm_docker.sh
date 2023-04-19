SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

docker stop gollvm
docker rm gollvm
docker run --name gollvm -it \
	-v $SCRIPTPATH/../:/zkGeth \
	-d zkgeth/ubuntu20_04_llvm /bin/bash

