# clone submodule with --depth 1 to save capacity
cd ../

if [ ! -d "riscv-gnu-toolchain" ]; then
    git clone --depth 1 --shallow-submodules https://github.com/riscv/riscv-gnu-toolchain
fi

cd riscv-gnu-toolchain
if [ -z "$(ls -A glibc)" ]; then
    rm -rf glibc
    git clone --depth 1 https://sourceware.org/git/glibc.git
fi


if [ -z "$(ls -A gcc)" ]; then
    rm -rf gcc
    git clone --depth 1 https://gcc.gnu.org/git/gcc.git
fi

if [ -z "$(ls -A binutils)" ]; then
    rm -rf binutils
    git clone --depth 1 https://sourceware.org/git/binutils-gdb.git binutils
fi

