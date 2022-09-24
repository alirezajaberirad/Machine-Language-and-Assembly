%include "in-out.asm"
%include "sys-equal.asm"

section .data
    error_memAlloc  db  "error in allocation memory", NL, 0
    error_memfree   db  "error in freeing memory", NL, 0

section .bss
    mem_size    resq    1
    n           resq    1
    startAdr    resq    1

section .text
    global main

main:
    call    readNum
    mov     [n],rax
    mul     rax
    mov     [mem_size],rax
    call    memalloc
    mov     [startAdr],rax

    push    qword   [n]
    push    qword   [startAdr]
    call    matrix


    call    memfree
    mov     rax,60
    mov     rdi,0
    syscall

matrix:
    enter   8,0
    mov     r11,[rbp+16];start address
    mov     r10,[rbp+24];number of columns
    xor     rsi,rsi;column index
    xor     rdi,rdi;row index
again:
    mov     rax,r10;rax=n
    mul     rdi;rax=n*rdi
    mov     rbx,rax
    lea     rbx,[rbx+rsi]
    lea     rbx,[rbx+r11]
    cmp     rsi,rdi
    je      setNum
    mov     rcx,r10
    sub     rcx,rsi
    dec     rcx
    cmp     rcx,rdi
    je      setNum
    mov     byte    [rbx],0
    mov     rax,0
    call    writeNum
backFromSet:
    inc     rsi
    cmp     rsi,r10
    je      setIndex

checkRowIndex:
    cmp     rdi,r10
    jl     again

endMatrix:
    leave
    ret

setNum:
    mov     rax,rdi
    inc     rax
    mov     [rbx],al
    call    writeNum
    jmp     backFromSet
    
setIndex:
    call    newLine
    xor     rsi,rsi
    inc     rdi
    jmp     checkRowIndex




memalloc:
    mov     rax,sys_mmap
    mov     rsi,[mem_size]

    mov     rdx,PROT_READ | PROT_WRITE
    mov     r10,MAP_ANONYMOUS|MAP_PRIVATE
    syscall
    cmp     rax,-1
    jg      memAllocEnd
    mov     rdi,error_memAlloc
    call    printString
memAllocEnd:
    ret


memfree:
    mov     rax,sys_mumap
    mov     rsi,mem_size

    mov     rdi,[startAdr]
    syscall
    cmp     rax,-1
    jg      memFreeEnd
    mov     rdi,error_memfree
    call    printString
memFreeEnd:
    ret

;runs correctly