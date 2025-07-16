timeout 1s spike --isa=RV32IMZICSR a.out < /dev/null
exit_code=$?
if [ $exit_code -eq 124 ]; then
    echo "Test TIMED OUT"
fi
