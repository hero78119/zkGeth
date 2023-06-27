mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
WORKING_DIR := $(dir $(mkfile_path))

.PHONY: demo_deassembly tools demo

dump_demo_assm:
	sudo docker run --rm -v  '$(WORKING_DIR):/zkGeth' -it zkgeth/riscv_toolchain bash -c "riscv64-unknown-linux-gnu-objdump -D /zkGeth/riscvgo/demo > /zkGeth/tools/demo.s"

dump_minigeth_assm:
	sudo docker run --rm -v  '$(WORKING_DIR):/zkGeth' -it zkgeth/riscv_toolchain bash -c "riscv64-unknown-linux-gnu-objdump -D /zkGeth/riscvgo/minigeth_risc > /zkGeth/tools/minigeth_risc.s"

tools:
	cd tools/ && bash clone.sh && sudo docker build -t zkgeth/riscv_toolchain -f Dockerfile .. --progress=plain
vm:
	cd $(WORKING_DIR)risc0-nova/risc0/r0vm && cargo build --release

build_demo:  
	#GOGC=off GOARCH=riscv64 go build -tags=faketime -buildvcs=false -o riscvgo/demo -gcflags="-N -l" -ldflags '-memprofile /tmp/123 -memprofilerate 1' riscvgo/demo.go
	# before go1.21, there is a bug in riscv64 memmove https://github.com/golang/go/commit/9552a1122f3334f6fa47c0cf718766af27255b84
	GOGC=off GOARCH=riscv64 ~/go/bin/go1.21rc1 build -tags=faketime -buildvcs=false -o riscvgo/demo -gcflags="-N -l" -ldflags '-memprofilerate 0' riscvgo/demo.go

extract_demo_symbol: execute_demo
	python3 extract_symbol.py trace.txt tools/demo.s trace_demo.txt

extract_minigeth_symbol:
	RUST_LOG=DEBUG $(WORKING_DIR)/risc0-nova/target/release/r0vm --elf $(WORKING_DIR)/riscvgo/minigeth_risc --memory-data /tmp/cannon/memory_data > trace.txt
	python3 extract_symbol.py trace.txt tools/minigeth.s trace_minigeth.txt

minigeth_risc:  
	#GOGC=off GOARCH=riscv64 go build -tags=faketime -buildvcs=false -o riscvgo/demo -gcflags="-N -l" -ldflags '-memprofile /tmp/123 -memprofilerate 1' riscvgo/demo.go
	cd $(WORKING_DIR)/riscvgo/; rm minigeth_risc; TARGETOS=linux TARGETARCH="riscv64" bash compile.sh 

minigeth_amd64:  
	#GOGC=off GOARCH=riscv64 go build -tags=faketime -buildvcs=false -o riscvgo/demo -gcflags="-N -l" -ldflags '-memprofile /tmp/123 -memprofilerate 1' riscvgo/demo.go
	cd $(WORKING_DIR)/riscvgo/ && TARGETOS=linux TARGETARCH="" bash compile.sh 
	# go build -tags=faketime -buildvcs=false -o riscvgo/minigeth -gcflags="-N -l" -ldflags '-memprofilerate 0' minigeth/main.go

execute_demo:
	RUST_LOG=DEBUG $(WORKING_DIR)/risc0-nova/target/release/r0vm --elf $(WORKING_DIR)/riscvgo/demo > trace.txt 2>&1

execute_minigeth_amd64:
	cd $(WORKING_DIR)/riscvgo/ && NODE=http://0.0.0.0:8545 ./minigeth_amd64 5 > trace_amd.txt 2>&1 # 5 is block number

demo: vm build_demo execute_demo
    
gen_block_data:
	NODE=http://0.0.0.0:8545 $(WORKING_DIR)/riscvgo/minigeth_amd64 5

execute_minigeth:
	$(WORKING_DIR)/risc0-nova/target/release/r0vm --elf $(WORKING_DIR)/riscvgo/minigeth_risc --memory-data /tmp/cannon/memory_data > trace.txt

geth_docker:
	docker-compose down -v --remove-orphans
	docker-compose up -d geth0
