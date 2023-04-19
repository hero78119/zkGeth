# zkGeth
zero knowledge proof for Go ethereum client geth

### Directory Layout

```
├── zkGeth
│   ├── gollvm_docker # docker environment for gollvm, currrently still work in progress
│   |   ├── clone.sh # clone repos for build
│   |   ├── build.sh # build docker image
|   |   ├── run_gofe_llvm_docker.sh # launch docker iamge in detach mode
│   ├── riscvgo # use go compiler with GOARCH=riscv64
|   ├── ├── compile.sh # entry file, compile minigeth and output as `minigeth.bin`
│   |   ├── build.sh # build script for go docker image compile minigeth
```

### Debug
to exec docker image with bash, `docker exec -it gollvm bash`

