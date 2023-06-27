#!/usr/bin/env bash
set -e
set -o xtrace

cd /minigeth
export GOGC=off
echo $GOARCH
case $GOARCH in
  amd64)
    go build -buildvcs=false -o /riscvgo/minigeth_amd64
    ;;
  riscv64)
    # go build -tags=faketime -buildvcs=false -o /riscvgo/minigeth_risc -gcflags="-N -l" -ldflags '-memprofilerate 0'
    go build -tags=faketime -buildvcs=false -o /riscvgo/minigeth_risc -gcflags=all="-d softfloat -N -l" -ldflags '-memprofilerate 0'
    ;;
  *)
    go build -buildvcs=false -o /riscvgo/minigeth_amd64
    ;;
esac

