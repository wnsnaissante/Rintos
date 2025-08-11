<h1 align="center">Rintos</h1>
<p align="center">A simple Operating System from scratch in Rust & NASM
</p>

## Overview

Rintos (inspired by Pintos) is a simple educational x86_64 operating system for self-study
<br><br>
**NOTE**: There may be tons of bugs and malfunctions.🥹

## Quickstart
**Before you proceed**: You will need NASM and QEMU for build and run.
> Tested on NASM version 2.16.03 & QEMU emulator version 10.0.92 
>

``` 
build.bat
```
```
qemu-system-x86_64 -fda rintos.img
```

## Roadmap
### v0.0.1 (1st Stage Bootloader | Real Mode) ✅
- [x] Enable A20 line & Check A20 activation
- [x] Basic Memory Initialization
- [x] Load 2nd stage Bootloader (from disk to memory and jump)

### v0.0.2 (2nd Stage Bootloader | Protected Mode) WIP
- [ ] Setup basic segment registers (CS, DS, ES, SS) and stack in real mode
- [ ] Setup Global Descriptor Table (GDT) for protected mode
- [ ] Transition from Real Mode (16-bit) to Protected Mode (32-bit)
- [ ] Setup basic stack and segment registers in protected mode
- [ ] Simple protected mode environment test (e.g., print message in 32-bit mode)

### v0.0.3 (2nd Stage Bootloader | Long Mode)
- [ ] Prepare for Long Mode (64-bit mode): setup PAE paging tables, enable CPU features needed for 64-bit mode
- [ ] Switch to Long Mode (64-bit mode) with basic 64-bit code stub