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

    # fd = file descriptor where to write
    # 1 = stdout
    li t1, 1
    sw t1, 8(t0)

    # pbuf = address of data to write
    # 16(a0): address of string start
    addi t1, a0, 16
    sw t1, 16(t0)

    # len = length of data to write
    # 12(a0): string length as Int
    lw t1, 12(a0)  # load address of Int
    lw t1, 12(t1)  # load value of Int
    sw t1, 24(t0)

    # make syscall
    la t0, tohost
    la t1, tohost_data
    sw t1, 0(t0)

    add a0, zero, zero

    ret

IO.out_int:
    # TODO:
    ret

.globl IO.in_string
IO.in_string:
    # temporarily, a0 is the address of the String object
    # TODO: allocate memory and remove this argument

    addi t2, a0, 16

_read_char:
    la t0, tohost_data
    # 63 = sys_read
    li t1, 63
    sw t1, 0(t0)

    # 0 = stdin
    li t1, 0
    sw t1, 8(t0)

    # address of where to store read byte
    # temporarily: address of string argument content
    sw t2, 16(t0)

    # 1 = length of data to read
    li t1, 1
    sw t1, 24(t0)

    # TODO: can 0 actually be read from stdin?
    # store 0, so that beqz can be used for _await_data
    sb zero, 0(t2)

    # make syscall
    la t0, tohost
    la t1, tohost_data
    sw t1, 0(t0)

    li t1, 0
    # loop until byte is read; this is necessary, since reading does not block:
    # the byte would just "magically" appear, when the simulator sets it
_await_data:
	# Load read byte in t1; Ctrl-C Spike and write `reg 0` to verify value
    lb t1, 0(t2)
    beqz t1, _await_data

    # increase "to-read" pointer
    addi t2, t2, 1

    # loop until newline is read
    li t0, 0x0a # newline character
    bne t1, t0, _read_char

    # move the pointer one char back to overwrite '\n'
    addi t2, t2, -1

    # store the length in the String
    addi t1, a0, 16
    sub t1, t2, t1
    lw t0, 12(a0)  # load address of Int
    sw t1, 12(t0)  # store value of Int

_pad_with_zeros:
    sb zero, 0(t2)

    addi t2, t2, 1
    andi t1, t2, 3
    bnez t1, _pad_with_zeros

    # store object size in the String
    addi t1, a0, 16
    sub t1, t2, t1
    sra t1, t1, 2
    sw t1, 4(a0)

    ret


IO.in_int:
    # TODO:
    ret

# ----------------- Int interface ----------------------------------------------

# custom interface / helper functions

# Reads the value of an Int object passed in $a0 and returns it in $a0.
# not .globl; TODO: maybe it should be?
Int.read_value:
    lw a0, 12(a0)
    ret

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
