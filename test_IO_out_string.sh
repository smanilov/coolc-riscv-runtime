riscv64-elf-gcc -c -mabi=ilp32 -march=rv32imzicsr -nostdlib cc-rv-rt.s
sed "s/IO\.out_string/IO_out_string/" -i cc-rv-rt.o 

riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_IO_out_string1.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_IO_out_string.out

if diff -q test_IO_out_string.out test_IO_out_string1.expected > /dev/null; then
    echo "1: PASSED"
else
    echo "1: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_IO_out_string2.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_IO_out_string.out

if diff -q test_IO_out_string.out test_IO_out_string2.expected > /dev/null; then
    echo "2: PASSED"
else
    echo "2: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_IO_out_string3.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_IO_out_string.out

if diff -q test_IO_out_string.out test_IO_out_string3.expected > /dev/null; then
    echo "3: PASSED"
else
    echo "3: FAILED"
fi
