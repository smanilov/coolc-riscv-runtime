riscv64-elf-gcc -c -mabi=ilp32 -march=rv32imzicsr -nostdlib cc-rv-rt.s
sed "s/Object\.abort/Object_abort/g" -i cc-rv-rt.o 
riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_Object_abort.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_Object_abort.out

if diff -q test_Object_abort.out test_Object_abort.expected > /dev/null; then
    echo "PASSED"
else
    echo "FAILED"
fi
