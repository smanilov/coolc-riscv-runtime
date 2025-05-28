## Attribution

The design of this runtime library draws conceptual inspiration from a MIPS
implementation (`trap.handler`, not included in this distribution), but it does
not include or derive from that code directly. The file `trap.handler` is
distributed under the license copied in `ACKNOWLEDGEMENTS`.

## License

This implementation (the one for RISC-V) is licensed under the MIT license, as
specified in the included file `LICENSE`.

## Implementation

The runtime is implemented in `cc-rv-rt.s`.

This implementation assumes the execution happens via the [Spike RISC-V
simulator][1]. At the time of writing, there is no documentation for it, so the
implementation of Spike is used as the specification (works as implemented TM).

[1]: https://github.com/riscv-software-src/riscv-isa-sim
