riscv64-elf-gcc -c -mabi=ilp32 -march=rv32imzicsr -nostdlib cc-rv-rt.s
riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib cc-rv-rt.o hello.s -T cc-rv-rt.ld -o a.out
