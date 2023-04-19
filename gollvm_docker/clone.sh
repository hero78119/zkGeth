# git fetch --depth=1 origin release/14.x
# git clone --depth 1 https://github.com/llvm/llvm-project.git

cd ../

if [ ! -d "riscv-gnu-toolchain" ]; then
    git clone --depth 1 --shallow-submodules https://github.com/riscv/riscv-gnu-toolchain
fi

if [ ! -d "llvm-project" ]; then
    git clone --depth 1 -b llvm-for-gollvm https://github.com/plctlab/llvm-project.git
fi


if [ ! -d "gollvm" ]; then
    git clone https://go.googlesource.com/gollvm
fi
cd gollvm && git reset --hard 9de48d3b5ed6b6aee744e458 && cd ..


if [ ! -d "gofrontend" ]; then
    git clone https://go.googlesource.com/gofrontend
fi
cd gofrontend && git reset --hard a62f20ae78ddd41be682dde8ca && cd ..


if [ ! -d "libffi" ]; then
    git clone https://github.com/libffi/libffi.git
fi
cd libffi && git reset --hard e504f90fe9123d25 && cd ..


if [ ! -d "libbacktrace" ]; then
    git clone https://github.com/ianlancetaylor/libbacktrace.git
fi
cd libbacktrace && git reset --hard 4d2dd0b172f2c9192f83ba93425f8 && cd ..
