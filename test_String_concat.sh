riscv64-elf-gcc -c -mabi=ilp32 -march=rv32imzicsr -nostdlib cc-rv-rt.s
sed "s/IO\.out_string/IO_out_string/g" -i cc-rv-rt.o 
sed "s/String\.concat/String_concat/g" -i cc-rv-rt.o 

riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_String_concat.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_String_concat.out

if diff -q test_String_concat.out test_String_concat.expected > /dev/null; then
    echo "PASSED"
else
    echo "FAILED"
fi
