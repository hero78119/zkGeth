#!/usr/bin/env bash
FILES=$(grep -v "#" files_minigeth)
MINIGETH=$PWD/minigeth
git clone https://github.com/ethereum/go-ethereum.git
cd go-ethereum
git checkout master
rsync -Rv $FILES $MINIGETH
