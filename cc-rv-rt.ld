/* This is the linker script for the COOL RISC-V runtime. */
/* Based on https://sourceware.org/binutils/docs/ld/index.html#SEC_Contents */
/* Based on https://mcyoung.xyz/2021/06/01/linker-script */
/* Based on https://github.com/avidan-efody/riscv-spike/.../default.lds */
/* Based on https://github.com/tock/tock/.../tock_kernel_layout.ld. */
/* Based on https://github.com/riscv-software-src/riscv-tests/../test.ld */
MEMORY {
    ram (rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS {
    .text : { *(.text); *(.text.*) }
    /DISCARD/ : { *(.comment); *(.riscv.attributes) }
}
