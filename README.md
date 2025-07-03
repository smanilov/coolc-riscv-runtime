# COOL RISC-V Runtime

A RISC-V runtime for the COOL programming language

## Specification

You can find the specification runtime in [Specification](specification.md). The
specification of this runtime library is based on [The Cool Runtime
System](https://web.stanford.edu/class/cs143/materials/cool-runtime.pdf)
specification document.

## License

The implementation is licensed under the MIT license, as specified in the
included file `LICENSE`.

## Implementation

The runtime is implemented in `cc-rv-rt.s`.

This implementation assumes the execution happens via the [Spike RISC-V
simulator][simulator-repo]. At the time of writing, there is no documentation for it, so the
implementation of Spike is used as the specification (works as implemented TM).

[simulator-repo]: https://github.com/riscv-software-src/riscv-isa-sim

## Usage

(instrucions for C; to be changed for COOL)

You need to have a RISCV64 bare-metal cross compiler installed, e.g. [GCC on
Arch](https://archlinux.org/packages/extra/x86_64/riscv64-elf-gcc/). You also
need to have Spike installed, but it easily builds from source (~10 min on a
laptop):

```
git clone https://github.com/riscv-software-src/riscv-isa-sim
cd riscv-isa-sim
mkdir build && cd build
../configure --prefix=/usr/local && make -j8 && sudo make install
```

Then you can build this runtime together with the dummy program and run it in
the simulator:

```
riscv64-elf-gcc -mabi=ilp32 -march=rv32izicsr -nostdlib -o a.out cc-rv-rt.s main.c -T cc-rv-rt.ld
spike -l --isa=RV32IZICSR a.out
```

You should get the assembly of the program printed out and control returned to
the shell.

## Spike `tohost` reference

See [Spike `tohost` reference](spike-tohost-reference.md) file.
