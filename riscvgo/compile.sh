if [[ ! -f minigeth ]]; then
    SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    sudo docker run --rm -v $SCRIPTPATH:/riscvgo -e GOOS=$TARGETOS -e GOARCH=$TARGETARCH -v $SCRIPTPATH/../minigeth:/minigeth --name 1.21rc2 -it golang:1.21rc2 bash /riscvgo/build.sh
fi

