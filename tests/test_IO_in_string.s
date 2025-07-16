.text

_inf_loop:
    j _inf_loop

.globl Main.main
Main.main:
    add fp, sp, 0

    sw ra, 0(sp)
    addi sp, sp, -4

    sw s1, 0(sp)
    addi sp, sp, -4
    add s1, a0, zero

    # input string

    sw fp, 0(sp)
    addi sp, sp, -4

    jal IO.in_string

    sw fp, 0(sp)
    addi sp, sp, -4

    la t0, _string1
    sw t0, 0(sp)
    addi sp, sp, -4

    sw a0, 0(sp)
    addi sp, sp, -4

    jal compare_strings

    beqz a0, Main.main.not_ok

Main.main.ok:
    add a0, s1, zero

    sw fp, 0(sp)
    addi sp, sp, -4

    la t0, _ok_string
    sw t0, 0(sp)
    addi sp, sp, -4

    jal IO.out_string

    j Main.main.end

Main.main.not_ok:
    add a0, s1, zero

    sw fp, 0(sp)
    addi sp, sp, -4

    la t0, _not_ok_string
    sw t0, 0(sp)
    addi sp, sp, -4

    jal IO.out_string

Main.main.end:
    addi sp, sp, 4
    lw s1, 0(sp)

    addi sp, sp, 4
    lw ra, 0(sp)

    addi sp, sp, 4
    lw fp, 0(sp)

    ret


# arguments passed on the stack; nothing in a0 (free function)
# returns 0 in a0 if strings differ; 1 if they are the same
compare_strings:
    add fp, sp, 0

    sw ra, 0(sp)
    addi sp, sp, -4

    lw t0, 4(fp)
    lw t1, 8(fp)

    # check if String
    li t4, 4
    lw t2, 0(t0)
    bne t2, t4, compare_strings.not_ok

    lw t2, 0(t1)
    bne t2, t4, compare_strings.not_ok

    # compare String lengths
    lw t2, 12(t0)
    lw t2, 12(t2)

    lw t3, 12(t1)
    lw t3, 12(t3)

    bne t2, t3, compare_strings.not_ok

    # compare object sizes
    lw t2, 4(t0)
    lw t3, 4(t1)

    bne t2, t3, compare_strings.not_ok

    # compare contents

    addi t2, t2, -4 # t2 = number of words in string
    addi t3, t0, 16
    addi t4, t1, 16

compare_strings.loop:
    lw t5, 0(t3)
    lw t6, 0(t4)

    bne t5, t6, compare_strings.not_ok

    addi t2, t2, -1
    addi t3, t3, 4
    addi t4, t4, 4
    bnez t2, compare_strings.loop

# compare_strings.ok:
    li a0, 1

    j compare_strings.end

compare_strings.not_ok:
    li a0, 0

compare_strings.end:
    addi sp, sp, 4
    lw ra, 0(sp)

    # pop arguments
    addi sp, sp, 8

    addi sp, sp, 4
    lw fp, 0(sp)
    ret


.data
# ------------- Name table of classes ------------------------------------------
.p2align 2
.globl class_nameTab
class_nameTab:
    .word Object_className
    .word IO_className
    .word Int_className
    .word Bool_className
    .word String_className
    .word Main_className

    .word -1 # GC tag
Object_classNameLength:
    .word 2  # class tag;       2 for Int
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Int has no methods
    .word 6  # first attribute; value of Int; default is 0

    .word -1 # GC tag
Object_className:
    .word 4  # class tag;       4 for String
    .word 6  # object size;     6 words (24 bytes); GC tag not included
    .word String_dispTab
    .word Object_classNameLength  # first attribute; pointer length
    .string "Object"
    .byte 0

    .word -1 # GC tag
IO_classNameLength:
    .word 2  # class tag;       2 for Int
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Int has no methods
    .word 2  # first attribute; value of Int; default is 0

    .word -1 # GC tag
IO_className:
    .word 4  # class tag;       4 for String
    .word 5  # object size;     5 words (20 bytes); GC tag not included
    .word String_dispTab
    .word IO_classNameLength  # first attribute; pointer length
    .string "IO" # includes terminating null char
    .byte 0

    .word -1 # GC tag
Int_classNameLength:
    .word 2  # class tag;       2 for Int
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Int has no methods
    .word 3  # first attribute; value of Int; default is 0

    .word -1 # GC tag
Int_className:
    .word 4  # class tag;       4 for String
    .word 5  # object size;     5 words (20 bytes); GC tag not included
    .word String_dispTab
    .word Int_classNameLength  # first attribute; pointer length
    .string "Int" # includes terminating null char

    .word -1 # GC tag
Bool_classNameLength:
    .word 2  # class tag;       2 for Int
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Int has no methods
    .word 4  # first attribute; value of Int; default is 0

    .word -1 # GC tag
Bool_className:
    .word 4  # class tag;       4 for String
    .word 6  # object size;     6 words (24 bytes); GC tag not included
    .word String_dispTab
    .word Bool_classNameLength  # first attribute; pointer length
    .string "Bool" # includes terminating null char
    .byte 0
    .byte 0
    .byte 0

    .word -1 # GC tag
String_classNameLength:
    .word 2  # class tag;       2 for Int
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Int has no methods
    .word 6  # first attribute; value of Int; default is 0

    .word -1 # GC tag
String_className:
    .word 4  # class tag;       4 for String
    .word 6  # object size;     6 words (24 bytes); GC tag not included
    .word String_dispTab
    .word String_classNameLength  # first attribute; pointer length
    .string "String" # includes terminating null char
    .byte 0

    .word -1 # GC tag
Main_classNameLength:
    .word 2  # class tag;       2 for Int
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Int has no methods
    .word 4  # first attribute; value of Int; default is 0

    .word -1 # GC tag
Main_className:
    .word 4  # class tag;       4 for String
    .word 6  # object size;     6 words (24 bytes); GC tag not included
    .word String_dispTab
    .word Main_classNameLength  # first attribute; pointer length
    .string "Main" # includes terminating null char
    .byte 0
    .byte 0
    .byte 0

# ------------- Prototype objects ----------------------------------------------
    .p2align 2
    .word -1 # GC tag
.globl Object_protObj
Object_protObj:
    .word 0  # class tag;       0 for Object
    .word 3  # object size;     3 words (12 bytes); GC tag not included
    .word Object_dispTab
    .word 0  # first attribute; value of Int; default is 0

    .word -1 # GC tag
.globl IO_protObj
IO_protObj:
    .word 2  # class tag;       2 for Int
    .word 3  # object size;     3 words (12 bytes); GC tag not included
    .word IO_dispTab

    .word -1 # GC tag
.globl Int_protObj
Int_protObj:
    .word 2  # class tag;       2 for Int
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Int has no methods
    .word 0  # first attribute; value of Int; default is 0

    .word -1 # GC tag
.globl Bool_protObj
Bool_protObj:
    .word 3  # class tag;       3 for Bool
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Bool has no methods
    .word 0  # first attribute; value of Bool; default is 0; means false

    .word -1 # GC tag
.globl String_protObj
String_protObj:
    .word 4  # class tag;       4 for String
    .word 5  # object size;     5 words (20 bytes); GC tag not included
    .word String_dispTab
    .word 0  # first attribute; pointer to Int that is the length of the String
    .word 0  # second attribute; terminating 0 character, since "" is default

    .word -1 # GC tag
.globl Main_protObj
Main_protObj:
    .word 4  # class tag;       4 for String
    .word 3  # object size;     5 words (20 bytes); GC tag not included
    .word Main_dispTab

# ------------- Dispatch tables ------------------------------------------------
.globl Object_dispTab
Object_dispTab:
    .word Object.abort
    .word Object.type_name
    .word Object.copy

.globl IO_dispTab
IO_dispTab:
    .word IO.out_string
    .word IO.in_string
    .word IO.out_int
    .word IO.in_int

.globl String_dispTab
String_dispTab:
    .word String.length
    .word String.concat
    .word String.substr

# no need to export symbols for user-defined types
Main_dispTab:
    .word IO.out_string
    .word IO.in_string
    .word IO.out_int
    .word IO.in_int

# ----------------- Init methods -----------------------------------------------

.globl Object_init
Object_init:
    # Most of the `init` functions of the default types are no-ops, so the
    # implementation is the same.

    # stack discipline:
    # callee:
    # - activation frame starts at the stack pointer
    add fp, sp, 0
    # - previous return address is first on the activation frame
    sw ra, 0(sp)
    addi sp, sp, -4
    # before using saved registers (s1 -- s11), push them on the stack

    # no op

    # stack discipline:
    # callee:
    # - restore used saved registers (s1 -- s11) from the stack
    # - ra is restored from first word on activation frame
    lw ra, 0(fp)
    # - ra, arguments, and control link are popped from the stack
    addi sp, sp, 8
    # - fp is restored from control link
    lw fp, 0(sp)
    # - result is stored in a0

    ret


.globl IO_init
IO_init:
    # Most of the `init` functions of the default types are no-ops, so the
    # implementation is the same.

    add fp, sp, 0
    sw ra, 0(sp)
    addi sp, sp, -4

    # no op

    lw ra, 0(fp)
    addi sp, sp, 8
    lw fp, 0(sp)
    ret


# Initializes an object of class Int passed in a0. In practice, a no-op, since
# Int_protObj already has the first (and only) attribute set to 0.
.globl Int_init
Int_init:
    # Most of the `init` functions of the default types are no-ops, so the
    # implementation is the same.

    add fp, sp, 0
    sw ra, 0(sp)
    addi sp, sp, -4

    # no op

    lw ra, 0(fp)
    addi sp, sp, 8
    lw fp, 0(sp)
    ret


# Initializes an object of class Bool passed in a0. In practice, a no-op, since
# Bool_protObj already has the first (and only) attribute set to 0.
.globl Bool_init
Bool_init:
    # Most of the `init` functions of the default types are no-ops, so the
    # implementation is the same.

    add fp, sp, 0
    sw ra, 0(sp)
    addi sp, sp, -4

    # no op

    lw ra, 0(fp)
    addi sp, sp, 8
    lw fp, 0(sp)
    ret


# Initializes an object of class String passed in a0. Allocates a new Int to
# store the length of the String and links the length pointer to it. Returns the
# initialized String in a0.
#
# Used in `new String`, but useless, in general, since it creates an empty
# string. String only has methods `length`, `concat`, and `substr`.
.globl String_init
String_init:
    # In addition to the default behavior, copies the Int prototype object and
    # uses that as the length, rather than the prototype object directly. No
    # practical reason for this, other than simulating the default init logic for
    # an object with attributes.

    add fp, sp, 0
    sw ra, 0(sp)
    addi sp, sp, -4

    # store String argument
    sw s1, 0(sp)
    addi sp, sp, -4
    add s1, a0, zero

    # copy Int prototype first

    la a0, Int_protObj
    sw fp, 0(sp)
    addi sp, sp, -4

    call Object.copy

    sw a0, 12(s1)      # store new Int as length; value of Int is 0 by default

    add a0, s1, zero   # restore String argument

    addi sp, sp, 4
    lw s1, 0(sp)
    lw ra, 0(fp)
    addi sp, sp, 8
    lw fp, 0(sp)

    ret


.globl Main_init
Main_init:
    # stack discipline:
    # callee:
    # - activation frame starts at the stack pointer
    add fp, sp, 0
    # - previous return address is first on the activation frame
    sw ra, 0(sp)
    addi sp, sp, -4
    # before using saved registers (s1 -- s11), push them on the stack

    # no op

    # stack discipline:
    # callee:
    # - restore used saved registers (s1 -- s11) from the stack
    # - ra is restored from first word on activation frame
    lw ra, 0(fp)
    # - ra, arguments, and control link are popped from the stack
    addi sp, sp, 8
    # - fp is restored from control link
    lw fp, 0(sp)
    # - result is stored in a0

    ret


# ------------- Class object table ---------------------------------------------
class_objTab:
    .word Object_protObj
    .word Object_init
    .word IO_protObj
    .word IO_init
    .word Int_protObj
    .word Int_init
    .word Bool_protObj
    .word Bool_init
    .word String_protObj
    .word String_init
    .word Main_protObj
    .word Main_init

    .word -1 # GC tag
_string1.length:
    .word 2  # class tag;       2 for Int
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Int has no methods
    .word 5  # first attribute; value of Int

    .word -1 # GC tag
_string1:
    .word 4  # class tag;       4 for String
    .word 6  # object size;     6 words (16 + 8 bytes); GC tag not included
    .word String_dispTab
    .word _string1.length # first attribute; pointer length
    .string "hello" # includes terminating null char
    .byte 0
    .byte 0

    .word -1 # GC tag
_ok_string.length:
    .word 2  # class tag;       2 for Int
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Int has no methods
    .word 5  # first attribute; value of Int

    .word -1 # GC tag
_ok_string:
    .word 4  # class tag;       4 for String
    .word 6  # object size;     6 words (16 + 8 bytes); GC tag not included
    .word String_dispTab
    .word _string1.length # first attribute; pointer length
    .string "good\n" # includes terminating null char
    .byte 0
    .byte 0

    .word -1 # GC tag
_not_ok_string.length:
    .word 2  # class tag;       2 for Int
    .word 4  # object size;     4 words (16 bytes); GC tag not included
    .word 0  # dispatch table;  Int has no methods
    .word 4  # first attribute; value of Int

    .word -1 # GC tag
_not_ok_string:
    .word 4  # class tag;       4 for String
    .word 6  # object size;     6 words (16 + 4 bytes); GC tag not included
    .word String_dispTab
    .word _string1.length # first attribute; pointer length
    .string "bad\n" # includes terminating null char
    .byte 0
    .byte 0
    .byte 0
