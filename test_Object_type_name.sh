riscv64-elf-gcc -c -mabi=ilp32 -march=rv32izicsr -nostdlib cc-rv-rt.s
sed "s/IO\.out_string/IO_out_string/g" -i cc-rv-rt.o 
sed "s/Object\.type_name/Object_type_name/g" -i cc-rv-rt.o 
riscv64-elf-gcc -mabi=ilp32 -march=rv32izicsr -nostdlib -o a.out cc-rv-rt.o test_Object_type_name.c -T cc-rv-rt.ld
spike --isa=RV32IZICSR a.out > test_Object_type_name.out

if diff -q test_Object_type_name.out test_Object_type_name.expected > /dev/null; then
    echo "PASSED"
else
    echo "FAILED"
fi
