riscv64-elf-gcc -c -mabi=ilp32 -march=rv32imzicsr -nostdlib cc-rv-rt.s
sed "s/IO\.out_string/IO_out_string/g" -i cc-rv-rt.o 
sed "s/String\.substr/String_substr/g" -i cc-rv-rt.o 

riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_String_substr1.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_String_substr.out

if diff -q test_String_substr.out test_String_substr1.expected > /dev/null; then
    echo "1: PASSED"
else
    echo "1: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_String_substr2.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_String_substr.out

if diff -q test_String_substr.out test_String_substr2.expected > /dev/null; then
    echo "2: PASSED"
else
    echo "2: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_String_substr3.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_String_substr.out

if diff -q test_String_substr.out test_String_substr3.expected > /dev/null; then
    echo "3: PASSED"
else
    echo "3: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_String_substr4.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_String_substr.out

if diff -q test_String_substr.out test_String_substr4.expected > /dev/null; then
    echo "4: PASSED"
else
    echo "4: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_String_substr5.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_String_substr.out

if diff -q test_String_substr.out test_String_substr5.expected > /dev/null; then
    echo "5: PASSED"
else
    echo "5: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_String_substr6.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_String_substr.out

if diff -q test_String_substr.out test_String_substr6.expected > /dev/null; then
    echo "6: PASSED"
else
    echo "6: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_String_substr7.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_String_substr.out

if diff -q test_String_substr.out test_String_substr7.expected > /dev/null; then
    echo "7: PASSED"
else
    echo "7: FAILED"
fi

riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib -o a.out cc-rv-rt.o test_String_substr8.c -T cc-rv-rt.ld
spike --isa=RV32IMZICSR a.out > test_String_substr.out

if diff -q test_String_substr.out test_String_substr8.expected > /dev/null; then
    echo "8: PASSED"
else
    echo "8: FAILED"
fi
