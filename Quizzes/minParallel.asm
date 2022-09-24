%include "in-out.asm"
%include "sys-equal.asm"
extern scanf
extern printf

section .data
    error_memAlloc  db  "error in allocation memory", NL, 0
    error_memfree   db  "error in freeing memory", NL, 0
    fmts  db  "%f",0
    fmtp  db  "%f",NL,0

section .bss
    n       resq    1
    mem_size resq   1
    startAdr resq   1

section .text
    global main

main:
    call    readNum
    mov     [n],rax
    imul    rax,16
    mov     [mem_size],rax
    call    writeNum
    call    memalloc
    mov     [startAdr],rax


    call readFloat

    push    rbp
    mov     rdi,fmtp
    mov     rax,1
    call    printf
    pop     rbp

    call    memfree
    mov     rax,60
    mov     rdi,0
    syscall

readFloat:
    mov     rcx,[n]
readAgain:
    mov     rbx,[startAdr]
    mov     rax,rcx
    imul    rax,16
    lea     rsi,[rbx+rax]
    add     rsi,rbx
    mov     rdi,fmts
    xor     rax,rax
    call    scanf

    loop    readAgain
    ret


min:
    mov     rdi,[n]
    imul    rdi,16
    xor     rcx,rcx
    xor     rbx,rbx
    mov     ebx,[startAdr]
    movdqa  xmm0,[rbx]

again:
    xor     rbx,rbx
    mov     ebx,[startAdr]
    movdqa  xmm1,[rbx+rcx]
    minps   xmm0,xmm1
    add     rcx,16
    cmp     rcx,rdi
    jl      again

    vpsrldq xmm1,xmm0,8 ;xmm1:0,0,x3,x2  and  xmm0:x3,x2,x1,x0
    minps   xmm0,xmm1   ;xmm0:0,0,min(x3,x1),min(x2,x0)
    vpsrldq xmm1,xmm0,4 ;xmm1:0,0,0,min(x3,x1)
    minps   xmm0,xmm1   ;xmm1:0,0,0,min(x3,x2,x1,x0)
    ret



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
; segmentation fault