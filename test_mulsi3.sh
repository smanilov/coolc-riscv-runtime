riscv64-elf-gcc -c -mabi=ilp32 -march=rv32imzicsr -nostdlib cc-rv-rt.s
sed "s/IO\.out_string/IO_out_string/g" -i cc-rv-rt.o 
riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_mulsi3.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out
