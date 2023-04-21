#!/usr/bin/env bash
set -e

cd /minigeth
export GOOS=linux
export GOARCH=riscv64
export GOGC=off
go build -buildvcs=false -o /riscvgo/minigeth

