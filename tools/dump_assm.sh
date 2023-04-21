if [[ ! -f minigeth.s ]]; then
    SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    echo "it took some time to dump...."
    sudo docker run --rm -v $SCRIPTPATH/../:/zkGeth -it zkgeth/riscv_toolchain bash -c "riscv64-unknown-linux-gnu-objdump -D /zkGeth/riscvgo/minigeth > /zkGeth/tools/minigeth.s"
fi

