mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
WORKING_DIR := $(dir $(mkfile_path))

.PHONY: demo_deassembly tools demo

dump_assm:
	sudo docker run --rm -v  '$(WORKING_DIR):/zkGeth' -it zkgeth/riscv_toolchain bash -c "riscv64-unknown-linux-gnu-objdump -D /zkGeth/riscvgo/demo > /zkGeth/tools/demo.s"

tools:
	cd tools/ && bash clone.sh && sudo docker build -t zkgeth/riscv_toolchain -f Dockerfile .. --progress=plain
vm:
	cd $(WORKING_DIR)risc0-nova/risc0/r0vm && cargo build --release

build_go:  
	#GOGC=off GOARCH=riscv64 go build -tags=faketime -buildvcs=false -o riscvgo/demo -gcflags="-N -l" -ldflags '-memprofile /tmp/123 -memprofilerate 1' riscvgo/demo.go
	GOGC=off GOARCH=riscv64 go build -tags=faketime -buildvcs=false -o riscvgo/demo -gcflags="-N -l" -ldflags '-memprofilerate 0' riscvgo/demo.go

execute:
	$(WORKING_DIR)/risc0-nova/target/release/r0vm --elf $(WORKING_DIR)/riscvgo/demo > trace.txt

demo: vm build_go execute 
    
