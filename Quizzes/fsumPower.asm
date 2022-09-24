%include "in-out.asm"
%include "twoToX.asm"
extern printf
extern scanf
section .data
    fmt db  "%lf",0
    fmtp    db  "Result=%lf",NL,0

section .bss
    x   resq    100
    n   resq    1
    result  resq    1

section .text
    global  main

main:
    call    readNum
    mov     [n],rax
    call    calculate
    push    rbp
    mov     rdi,fmtp
    movq    xmm0,[result]
    mov     rax,1
    call    printf
    pop     rbp

    mov     rax,60
    mov     rdi,0
    syscall

calculate:
    mov     rbx,0
    mov     rcx,[n]
getInput:
    push    rcx
    push    rbx
    push    rbp
    push    rsi
    mov     rsi,x 
    add     rsi,rbx
    mov     rdi,fmt
    xor     rax,rax
    call    scanf
    
    pop     rsi
    pop     rbp
    fld   qword  [x+rbx]
    call    TwoToX
    fstp  qword  [x+rbx]

    pop     rbx
    pop     rcx
    add     rbx,8

    loop    getInput
    mov     rcx,[n]
    mov     rbx,0
    mov   qword  [result],0
sum:

    fld   qword  [result]
    fadd  qword  [x+rbx]
    fstp  qword  [result]
    add     rbx,8
    loop    sum
end:

    ret


;runs correctly