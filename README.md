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
.\build.bat
```
```
qemu-system-x86_64 -drive file=rintos.img,format=raw
```

## Roadmap
### v0.0.1 (1st Stage Bootloader | Real Mode) ✅
- [x] Enable A20 line & Check A20 activation
- [x] Basic Memory Initialization
- [x] Load 2nd stage Bootloader (from disk to memory and jump)

### v0.0.2 (2nd Stage Bootloader | Protected Mode) WIP
- [x] Setup basic segment registers (CS, DS, ES, SS) and stack in real mode
- [x] Setup Global Descriptor Table (GDT) for protected mode
- [x] Transition from Real Mode (16-bit) to Protected Mode (32-bit)
- [x] Setup basic stack and segment registers in protected mode
- [x] Simple protected mode environment test (e.g., print message in 32-bit mode)

### v0.0.3 (2nd Stage Bootloader | Long Mode)
- [x] Create 64-bit GDT (L-bit code, flat data)
- [ ] Build minimal identity-mapped paging for long mode (2MiB large page covering 0–2MiB)
- [ ] Enable long mode: CR4.PAE, CR3=PML4, EFER.LME, CR0.PG
- [ ] Far jump to 64-bit code selector and run 64-bit stub
- [ ] In 64-bit mode, set stack and print a test string to 0xB8000
- [ ] Build and load 64-bit IDT (with basic exception stubs)
- [ ] Remap PIC to 0x20–0x2F and unmask IRQ1 (keyboard)
- [ ] Install 64-bit keyboard ISR at vector 0x21 and send EOI on 0x20
- [ ] Enable interrupts (sti) and verify scancode reception