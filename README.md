# hard-coding

## tools

- qemu: emulator
- binutils: gnu tools
- gcc: c compiler
- nasm: assembler
- bochs: x86 simulator

## usage

### bochs

```shell
bochs -f bochsrc
r    # show registers' value
sreg # show segment registers' value
xp /8bx 0x7c00 # show memory storage
n    # execute a line of instruction
b 0x7c00 # make a breakpoint
c        # run until breakpoint
```

### gnu assember(at&t)


### nasm

instructions related to compiler:

- org 07c00h
- equ
- bits

