# This is the assembly code for the COOL RISC-V runtime.

# Global _start symbol: the entry point of the runtime.
.globl _start
_start:
    call main

# Epilogue of the runtime
_end:
    # The next three lines tell Spike to stop the simulation.
    # la t0, tohost
    # li t1, 1
    # sw t1, 0(t0)
    # Infinite loop until the simulation stops.
_inf_loop:
    j _inf_loop


# ------------- Implementation of predefined classes -------------

# Initializes an object of class Int passed in $a0.
.globl Int_init
Int_init:
    li t0, 100
    sw t0, 12(a0)
    la t1, tohost
    ret

.data
# Special symbols `tohost` and `fromhost` used to interact with the Spike
# simulator.
tohost:
    .dword 0

fromhost:
    .dword 0
