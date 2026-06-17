; ==============================================================================
; hello.asm
; 
; Educational "Hello, World!" in x86-64 Assembly (NASM syntax)
; Written for Computer Science students learning low-level systems programming.
;
; Target: Linux x86-64 (perfect for WSL on Windows)
;
; This tiny program performs ONLY two system calls:
;   1. write()  - print our greeting directly to stdout
;   2. exit()   - terminate the process cleanly
;
; There is NO C standard library, NO runtime, NO printf, NO main().
; We speak directly to the Linux kernel.
;
; Build:
;     make
;     ./hello
;
; Or manually:
;     nasm -f elf64 hello.asm -o hello.o
;     ld hello.o -o hello
;     ./hello
;
; Output:
;     Hello, World! <3 from Wold Labs
;
; ==============================================================================


; ------------------------------------------------------------------------------
; .data section
; Initialized read-only data lives here (our string is stored in the binary).
; ------------------------------------------------------------------------------
section .data

    ; Define the bytes of our greeting message.
    ; "db" = Define Byte. We can put ASCII characters and numbers together.
    ; The newline (line feed) is 0x0A (decimal 10).
    msg db "Hello, World! <3 from Wold Labs", 0x0A

    ; This is a compile-time constant (not a runtime variable).
    ; "$" means "the current assembly location".
    ; Subtracting the start of the label from the current location gives us the exact
    ; number of bytes in the string. This is the standard, reliable way to get
    ; string lengths in assembly — never count by hand!
    msg_len equ $ - msg


; ------------------------------------------------------------------------------
; .text section
; All executable code goes in .text.
; ------------------------------------------------------------------------------
section .text

    ; The linker (ld) will start execution at the symbol marked "global _start".
    ; This is the traditional entry point name when you do not link against crt*.o
    ; (the C runtime startup code that normally calls main()).
    global _start

_start:
    ; ======================================================================
    ; System call: write(1, msg, msg_len)
    ; ======================================================================
    ; Linux x86-64 syscall calling convention (for syscalls, not C functions):
    ;   rax = syscall number
    ;   rdi = first argument (file descriptor)
    ;   rsi = second argument (buffer pointer)
    ;   rdx = third argument (byte count)
    ;   (rcx, r8, r9 used for additional args in other syscalls)
    ;
    ; After arguments are set, "syscall" transfers control to the kernel.

    mov rax, 1              ; syscall #1 = write on Linux x86-64
    mov rdi, 1              ; file descriptor 1 = standard output (stdout)
    mov rsi, msg            ; address of the string (the label becomes a memory address)
    mov rdx, msg_len        ; exactly how many bytes to write
    syscall                 ; ask the kernel to perform the write

    ; ======================================================================
    ; System call: exit(0)
    ; ======================================================================
    ; We must exit explicitly. If we just fall off the end of _start the
    ; process will usually be killed by the kernel (or crash).
    ;
    ; Exit code 0 = success. The shell will show a normal prompt afterward.

    mov rax, 60             ; syscall #60 = exit on Linux x86-64
    mov rdi, 0              ; exit status code (0 = successful)
    syscall                 ; tell the kernel "we are done"


; ------------------------------------------------------------------------------
; Student Notes & Experiments
; ------------------------------------------------------------------------------
; 1. The entire useful program is  the two mov + syscall blocks above.
; 2. Try changing the string in .data and reassembling. The length updates automatically.
; 3. Try writing to stderr instead: change the first "mov rdi, 1" to "mov rdi, 2".
; 4. What happens if you forget the 0x0A newline?
; 5. Use "objdump -d hello" after building to see the actual machine code bytes
;    that the CPU executes.
; 6. Load it in gdb and use "stepi" (step instruction) to watch rax, rdi, etc. change.
; ------------------------------------------------------------------------------
