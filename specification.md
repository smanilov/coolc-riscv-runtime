# COOL RISC-V Runtime

## Introduction

The runtime system consists of a set of hand-coded assembly language functions that are used as subroutines by COOL programs. It contains four classes of routines:

1. startup code, which invokes the main method of the main program;
2. the code for methods of predefined classes (Object, IO, String);
3. a few special procedures needed by Cool programs to test objects for equality
   and handle runtime errors;
4. garbage collectors.

The COOL RISC-V runtime system is implemented in the file `cc-rv-rt.s`. It can
be linked together with other assembly code using `ld` and the `cc-rv-rt.ld`
linker script like so:

TODO: check that this works

```
ld program.s cc-rv-rt.s -T cc-rv-rt.ld -o program.out
```

The following sections describe what the Cool runtime system assumes about the generated code
and what the runtime system provides to the generated code.

## Objects

TODO:

## Extra helpers

Here are some additional functions that are provided in this runtime library:

1. _string_compare
2. ...

These functions follow the COOLC calling convention. Function-specific sections
give more details.

### _string_compare

_string_compare takes a "this" argument and one additional argument to compare
it with. It assumes both arguments are of type String.

