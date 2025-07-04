riscv64-elf-gcc -c -mabi=ilp32 -march=rv32izicsr -nostdlib cc-rv-rt.s
sed "s/IO\.out_string/IO_out_string/g" -i cc-rv-rt.o 
sed "s/IO\.in_string/IO_in_string/g" -i cc-rv-rt.o 
riscv64-elf-gcc -mabi=ilp32 -march=rv32izicsr -nostdlib -o a.out cc-rv-rt.o test_IO_in_string.c -T cc-rv-rt.ld
spike --isa=RV32IZICSR a.out < test_IO_in_string.in > test_IO_in_string.out

if diff -q test_IO_in_string.out test_IO_in_string.expected > /dev/null; then
    echo "PASSED"
else
    echo "FAILED"
fi
