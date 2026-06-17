# HelloWorld

**x86-64 Assembly Edition**

A minimal, educational "Hello, World!" written in pure x86-64 assembly language (NASM syntax).

> Hello, World! <3 from Wold Labs

Perfect for Computer Science students who want to understand what really happens when a program runs.

You will learn:
- How programs communicate directly with the Linux kernel via syscalls
- CPU registers and the syscall calling convention
- The difference between `.data` and `.text` sections
- The assemble + link process (no C runtime, no `libc`)
- How to inspect real binaries with `objdump`, `readelf`, and `gdb`

## Quick Start (Linux or WSL)

### Install NASM

```bash
# Ubuntu / Debian / WSL
sudo apt update && sudo apt install nasm build-essential

# macOS (Homebrew) - note: syscall numbers differ
# brew install nasm
```

### Build & Run

```bash
make
./hello
```

You will see:

```
Hello, World! <3 from Wold Labs
```

### Manual Build (no Makefile)

```bash
nasm -f elf64 hello.asm -o hello.o
ld hello.o -o hello
./hello
```

### Clean up build files

```bash
make clean
```

## The Assembly Code

Open **[hello.asm](hello.asm)**. It is deliberately small (~30 lines of real code) and **heavily commented** so you can follow along line by line.

Key concepts explained inside the source:

- `section .data` — where our string constant lives
- `db` (define byte) + the `$ - label` trick to compute string length at assembly time
- `global _start` — the real entry point (no `main()` because we have no C runtime)
- Setting up registers for the `write` and `exit` syscalls
- The single `syscall` instruction that asks the kernel to do work

## Code Walkthrough (Student Notes)

```asm
; 1. Tell the linker where to start execution
 global _start
_start:

; 2. write(1 /*stdout*/, msg, length)
 mov rax, 1          ; write syscall number (Linux x86-64)
 mov rdi, 1          ; file descriptor 1 = stdout
 mov rsi, msg        ; address of our string
 mov rdx, msg_len    ; how many bytes
 syscall

; 3. exit(0)
 mov rax, 60         ; exit syscall number
 mov rdi, 0          ; success
 syscall
```

That's the entire "app"! Two kernel calls, direct register manipulation, and you're done.

## Exercises for Students

Try these in order:

1. **Change the message** — Edit the string in `.data`, run `make` again. Notice that `msg_len` automatically updates.
2. **Print two lines** — Duplicate the entire write block (different message or same).
3. **Print to stderr** — Change `mov rdi, 1` to `mov rdi, 2`. Where does the output go?
4. **Remove the newline** — Delete `, 0x0A` from the string. See how your shell prompt looks afterward.
5. **Make it say your name** — Append more text to the message.
6. **Inspect the binary** (highly recommended):
   ```bash
   file hello                 # ELF 64-bit ...
   ls -l hello                # tiny! usually < 2 KB
   objdump -d hello           # disassemble the machine code
   readelf -a hello | head -30
   hexdump -C hello | head
   size hello
   ```
7. **Single-step in the debugger**:
   ```bash
   gdb ./hello
   (gdb) break _start
   (gdb) run
   (gdb) info registers rax rdi rsi rdx
   (gdb) stepi
   (gdb) stepi
   ...
   ```
   Watch exactly how the registers and instruction pointer change.

8. **Advanced**:
   - Add a `read` syscall (number `0`) to accept input from the user and echo it back.
   - Push the message bytes onto the stack and print from `[rsp]`.
   - Write a version that prints the number 42 (you'll need to convert integer to ASCII yourself).

## Platform Notes

- **Linux & WSL (Windows Subsystem for Linux)**: This code works exactly as written (syscalls 1 and 60).
- **macOS**: Syscall numbers are different (`write` = `0x2000004`, `exit` = `0x2000001`). The entry label is sometimes `_main`. You can usually get it running with small edits + `ld -macosx_version_min ...` or by using `clang` to link.
- **Native Windows**: Use WSL (strongly recommended for this exercise). Pure Windows assembly uses different ABIs and usually the `WriteFile` Win32 API or MASM + the Microsoft linker.

## Why Learn This?

Every high-level language eventually compiles down to something like this. Understanding assembly gives you superpowers:
- You finally understand what a compiler is doing
- Buffer overflows, ROP chains, and many security concepts become obvious
- You can debug performance problems that no profiler explains
- You gain respect for (and the ability to optimize) the code you write in C, Rust, Go, etc.

This 1.5 KB program does what a `printf` call hides behind thousands of lines of library and runtime code.

## Build Artifacts

The `Makefile` makes the experience pleasant for students while still showing the raw `nasm` + `ld` commands.

## Credits

Built with <3 from Wold Labs for the next generation of low-level programmers.

---

*Previous versions of this repo contained a Python CLI and an interactive web demo. They have been removed so the repository stays sharply focused on assembly language education.*