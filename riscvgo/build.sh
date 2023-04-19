#!/usr/bin/env bash
set -e

cd /minigeth
export GOOS=linux
export GOARCH=riscv64
go build -buildvcs=false -o /riscvgo/minigeth

