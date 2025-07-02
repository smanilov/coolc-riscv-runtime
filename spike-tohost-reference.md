## Spike `tohost` reference

Looking at the code for the Spike simulator, the `tohost` interface seems to
work in the following way (at the time of writing, May 2025).

### Enabling

In order to use the `tohost`/`fromhost` mechanism, the simulated executable
needs to define symbols `tohost` and `fromhost`. If either of them is not
defined, Spike will print a warning and start the simulation without
`tohost`/`fromhost` support.

Example assembly to define the symbols:

```
tohost:
    .dword 0

fromhost:
    .dword 0
```

### Encoding

When the executable writes to `tohost`, it takes the simulator some time to
notice this effect. When it does, it resets the value to 0. (TODO: can this be
used to detect in the executable when the "syscall" has been handled?) The value
that is written to `tohost` is interpreted in the following way.

The `tohost` and `fromhost` values are 64-bit wide. The first 16 bits of
`tohost` contain the target device (first 8 bits) and command (next 8 bits). The
last 48 bits contain the "payload", i.e. the command-specific information sent
by the executable.

```
+---------+---------+---------+---------+---------+---------+---------+---------+
|  device | command |                          payload                          |
+---------+---------+---------+---------+---------+---------+---------+---------+
|  8 bits |  8 bits |                          48 bits                          |
+---------+---------+---------+---------+---------+---------+---------+---------+
```

There are two devices registered by default: syscall\_proxy and bcd (terminal IO;
who knows where the name comes from...). There are additional devices that are
defined in the source code but are not registered by default. (TODO: are there
CLI flags that register them?)

The syscall\_proxy device registeres a single command: syscall. It checks
whether the last bit is set. If it is then the value is shifted right by one bit
(divided by 2) and treated as a return value. If the return value is not zero, a
"FAILED" message is printed like so:

```
*** FAILED *** (tohost = 31)
```

Note that the value written to `tohost` was 63 in this case. The printed value
is wrongly called `tohost` in the printed message. It is the integer part of
dividing `tohost` by 2.

If the last bit is not set, then the payload is "dispatched".

### Syscall Encoding

Dispatching a syscall is not as simple as writing the syscall opcode to
`tohost`. If the opcode is an odd number (e.g. `sysexit` has opcode `93`), then
it will be divided by two and treated as an error number while the program is
being terminated (see previous section).

Instead, one needs to have a dedicated part of the memory to serve as the data
passed to the syscall. It is a maximum of 8 64-bit numbers, so 64 bytes in
total. Then, when invoking a syscall, this dedicated part of the memory needs to
be set with the opcode and arguments to the syscall. Then the address to the
data needs to be written in `tohost`.

Here is an example that calls `sysexit` with a value of 42:

```
    la t0, tohost_data
    li t1, 93
    sw t1, 0(t0)

    addi t0, t0, 8
    li t1, 42
    sw t1, 0(t0)

    la t0, tohost
    la t1, tohost_data
    sw t1, 0(t0)

...

# Data to send to `tohost`
tohost_data:
    .dword 0, 0, 0, 0, 0, 0, 0, 0
```

Note that this internally will store the `exitcode` as 85. This is because it is
not allowed to be a zero, so the provided value is doubled and one is added to
make sure this holds. Curiously, a "FAILED" message is not printed if sys\_exit
is used instead of writing an odd number to `tohost` (the other way of halting
the simulation).

The list of syscalls is given in [`syscall.cc`][syscall-source] in the code of
the Simulator (search for `table`). There are quite a few of them, some of which
return a value. This value is written at the same address where the syscall
opcode was specified (`tohost_data` in the previous example).

[syscall-source]: https://github.com/riscv-software-src/riscv-isa-sim/blob/master/fesvr/syscall.cc

Other than `sys_exit`, let's take a look at `sys_read`, which invokes the POSIX
`read` command on the host. Here's an example RISC-V assembly that calls
`sys_read` in Spike:

```
    la t0, tohost_data
    # 63 = sys_read
    li t1, 63
    sw t1, 0(t0)

    addi t0, t0, 8
    # 0 = stdin
    li t1, 0
    sw t1, 0(t0)

    addi t0, t0, 8
    # stdin_byte = address of where to store read byte
    la t1, stdin_byte
    sw t1, 0(t0)

    addi t0, t0, 8
    # 1 = length of data to read
    li t1, 1
    sw t1, 0(t0)

    # make syscall
    la t0, tohost
    la t1, tohost_data
    sw t1, 0(t0)

    # Infinite loop
_inf_loop:
	# Load read byte in t1; Ctrl-C Spike and write `reg 0` to verify value
    la t0, stdin_byte
    lb t1, 0(t0)
    j _inf_loop

# Special symbols `tohost` and `fromhost` used to interact with the Spike
# simulator. Aligned to 2^4=16 bytes, although probably not necessary.
.p2align 4
tohost:
    .dword 0

fromhost:
    .dword 0

# Data to send to `tohost`
tohost_data:
    .dword 0, 0, 0, 0, 0, 0, 0, 0

stdin_byte:
    .byte 0
```

In general, the source of Spike is quite readable and a good list of POSIX
commands are supported. In addition to those, a terminal is supported via
termios from libc, as well as disk read/write via an optional device. Disk RW
can be achieved via the POSIX syscalls too. Finally, there's even an optional
remote frame buffer device, which can be used to display graphics on the host
machine, that are generated in the RISC-V executable.
