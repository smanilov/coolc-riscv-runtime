bless=false
if [ "$1" == "bless" ]; then
    bless=true
fi

riscv64-elf-gcc -c -mabi=ilp32 -march=rv32imzicsr -nostdlib cc-rv-rt.s

for test_source in $(ls tests/test_*.s); do
	test_file=$(basename $test_source)
    testname="${test_file%.s}"
    input_file="tests/${testname}.in"
    if [[ ! -f "$input_file" ]]; then
        input_file="/dev/null"
    fi

    riscv64-elf-gcc -mabi=ilp32 -march=rv32imzicsr -nostdlib cc-rv-rt.o ${test_source} -T cc-rv-rt.ld -o a.out

    if $bless; then
        spike --isa=RV32IMZICSR a.out < "$input_file" > tests/${testname}.expected.out
    else
        timeout 1s spike --isa=RV32IMZICSR a.out < "$input_file" > tests/${testname}.out
        exit_code=$?
        if [ $exit_code -eq 124 ]; then
            echo "Test ${testname} TIMED OUT"
        elif ! diff -a tests/${testname}.expected.out tests/${testname}.out; then
            echo "Test ${testname} FAILED"
        else
            echo "Test ${testname} PASSED"
        fi
    fi
done
