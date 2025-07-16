bless=false
if [ "$1" == "bless" ]; then
    bless=true
fi

riscv64-elf-gcc -c -mabi=ilp32 -march=rv32imzicsr -nostdlib cc-rv-rt.s

for test_source in $(ls test_*.s); do
    testname="${test_source%.s}"

    riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib cc-rv-rt.o ${test_source} -T cc-rv-rt.ld -o a.out

    if $bless; then
        spike --isa=RV32IMZICSR a.out < ${testname}.in > ${testname}.expected.out
    else
        timeout 1s spike --isa=RV32IMZICSR a.out < ${testname}.in > ${testname}.out
        exit_code=$?
        if [ $exit_code -eq 124 ]; then
            echo "Test ${testname} TIMED OUT"
        elif ! diff ${testname}.expected.out ${testname}.out; then
            echo "Test ${testname} FAILED"
        else
            echo "Test ${testname} PASSED"
        fi
    fi
done
