./compile-lib.sh
riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib cc-rv-rt.o hello.s -T cc-rv-rt.ld -o a.out
