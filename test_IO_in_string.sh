riscv64-elf-gcc -c -mabi=ilp32 -march=rv32izicsr -nostdlib cc-rv-rt.s
sed "s/IO\.out_string/IO_out_string/g" -i cc-rv-rt.o 
sed "s/IO\.in_string/IO_in_string/g" -i cc-rv-rt.o 
riscv64-elf-gcc -mabi=ilp32 -march=rv32izicsr -nostdlib -o a.out cc-rv-rt.o test_IO_in_string1.c -T cc-rv-rt.ld
spike --isa=RV32IZICSR a.out < test_IO_in_string.in > test_IO_in_string.out

if diff -q test_IO_in_string.out test_IO_in_string1.expected > /dev/null; then
    echo "1: PASSED"
else
    echo "1: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32izicsr -nostdlib -o a.out cc-rv-rt.o test_IO_in_string2.c -T cc-rv-rt.ld
spike --isa=RV32IZICSR a.out < test_IO_in_string.in > test_IO_in_string.out

if diff -q test_IO_in_string.out test_IO_in_string2.expected > /dev/null; then
    echo "2: PASSED"
else
    echo "2: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32izicsr -nostdlib -o a.out cc-rv-rt.o test_IO_in_string3.c -T cc-rv-rt.ld
spike --isa=RV32IZICSR a.out < test_IO_in_string.in > test_IO_in_string.out

if diff -q test_IO_in_string.out test_IO_in_string3.expected > /dev/null; then
    echo "3: PASSED"
else
    echo "3: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32izicsr -nostdlib -o a.out cc-rv-rt.o test_IO_in_string4.c -T cc-rv-rt.ld
spike --isa=RV32IZICSR a.out < test_IO_in_string.in > test_IO_in_string.out

if diff -q test_IO_in_string.out test_IO_in_string4.expected > /dev/null; then
    echo "4: PASSED"
else
    echo "4: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32izicsr -nostdlib -o a.out cc-rv-rt.o test_IO_in_string5.c -T cc-rv-rt.ld
spike --isa=RV32IZICSR a.out < test_IO_in_string.in > test_IO_in_string.out

if diff -q test_IO_in_string.out test_IO_in_string5.expected > /dev/null; then
    echo "5: PASSED"
else
    echo "5: FAILED"
fi
