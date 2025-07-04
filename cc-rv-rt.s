# This is the assembly code for the COOL RISC-V runtime.

# Global _start symbol: the entry point of the runtime.
.globl _start
_start:
    call main

# Epilogue of the runtime
_end:
    li t0, 10000 # number of iterations of delay loop; 10000 seem to be enough
_delay_termination:
    addi t0, t0, -1
    bnez t0, _delay_termination
    
    # The next three lines tell Spike to stop the simulation.
    la t0, tohost
    li t1, 1
    sw t1, 0(t0)
    # Infinite loop until the simulation stops.
_inf_loop:
    j _inf_loop


# ------------- Implementation of predefined classes ---------------------------

# ----------------- Init methods -----------------------------------------------

.globl Object_init
Object_init:
    ret

.globl IO_init
IO_init:
    ret

# Initializes an object of class Int passed in $a0. In practice, a no-op, since
# Int_protObj already has the first (and only) attribute set to 0.
.globl Int_init
Int_init:
    ret

# Initializes an object of class Int passed in $a0. In practice, a no-op, since
# Bool_protObj already has the first (and only) attribute set to 0.
.globl Bool_init
Bool_init:
    ret

.globl String_init
String_init:
    # TODO:
    ret

# ----------------- Object interface -------------------------------------------

Object.abort:
    # TODO:
    ret

Object.type_name:
    # TODO:
    ret

Object.copy:
    # TODO:
    ret

# ----------------- IO interface -----------------------------------------------

.globl IO.out_string
IO.out_string:
    la t0, tohost_data
    # 64 = sys_write
    li t1, 64
    sw t1, 0(t0)

    addi t0, t0, 8
    # fd = file descriptor where to write
    # 1 = stdout
    li t1, 1
    sw t1, 0(t0)

    addi t0, t0, 8
    # pbuf = address of data to write
    # 16(a0): address of string start
    addi t1, a0, 16
    sw t1, 0(t0)

    addi t0, t0, 8
    # len = length of data to write
    # 4(a0): string object size = length / 4 + 4
    lw t1, 4(a0)
    addi t1, t1, -4
    slli t1, t1, 2
    sw t1, 0(t0)

    # make syscall
    la t0, tohost
    la t1, tohost_data
    sw t1, 0(t0)

    ret

IO.out_int:
    # TODO:
    ret

IO.in_string:
    # TODO:
    ret

IO.in_int:
    # TODO:
    ret

# ----------------- Int interface ----------------------------------------------

# none

# ----------------- String interface -------------------------------------------

String.length:
    # TODO:
    ret

String.concat:
    # TODO:
    ret

String.substr:
    # TODO:
    ret

# ----------------- Bool interface ---------------------------------------------

# none

# ------------- End of implementation of predefined classes --------------------

.data

# ------------- Spike interop --------------------------------------------------

# Special symbols `tohost` and `fromhost` used to interact with the Spike
# simulator.
.p2align 4
tohost:
    .dword 0

fromhost:
    .dword 0

tohost_data:
    .dword 0, 0, 0, 0, 0, 0, 0, 0

fromhost_data:
    .dword 0, 0, 0, 0, 0, 0, 0, 0

# ------------- Prototype objects ----------------------------------------------

    .word -1 # GC tag
Object_protObj:
    .word 0  # class tag;       0 for Object
    .word 3  # object size;     3 words (12 bytes); GC tag not included
    .word Object_dispTab
    .word 0  # first attribute; value of Int; default is 0

    .word -1 # GC tag
IO_protObj:
    .word 2  # class tag;       2 for Int
    .word 3  # object size;     3 words (12 bytes); GC tag not included
    .word IO_dispTab

    .word -1 # GC tag
Int_protObj:
    .word 2  # class tag;       2 for Int
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Int has no methods
    .word 0  # first attribute; value of Int; default is 0

    .word -1 # GC tag
Bool_protObj:
    .word 3  # class tag;       3 for Bool
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Bool has no methods
    .word 0  # first attribute; value of Bool; default is 0; means false

    .word -1 # GC tag
String_protObj:
    .word 4  # class tag;       4 for String
    .word 5  # object size;     5 words (20 bytes); GC tag not included
    .word String_dispTab
    .word 0  # first attribute; pointer to Int that is the length of the String
    .word 0  # second attribute; terminating 0 character, since "" is default

Object_dispTab:
    .word Object.abort
    .word Object.type_name
    .word Object.copy

IO_dispTab:
    .word IO.out_string
    .word IO.in_string
    .word IO.out_int
    .word IO.in_int

String_dispTab:
    .word String.length
    .word String.concat
    .word String.substr

# ------------- End of prototype objects ---------------------------------------
