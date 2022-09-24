%include "in-out.asm"
extern  scanf
extern  printf

section .data
    userMsg db  "first enter n then x: ",NL,0
    fmts    db  "%lf",0
    fmtp    db  "The result of serie is: %lf",NL,0

section .bss
    n   resq    1
    x   resq    1
    k   resd    1
    sum resq    1
    prevElement     resq    1

section .text
    global main

main:
    push    rbp
    mov     rdi,userMsg
    mov     rax,0
    call    printf
    pop     rbp

    call    readNum
    mov     [n],rax

    push    rax
    push    rbp
    push    rsi
    mov     rsi,x
    mov     rdi,fmts
    xor     rax,rax
    call    scanf
    pop     rsi
    pop     rbp
    pop     rax

    call    serie
    
    push    rbp
    mov     rdi,fmtp
    movq    xmm0,[sum]
    mov     rax,1
    call    printf
    pop     rbp

    mov     rax,60
    mov     rdi,0
    syscall

serie:
    mov     rcx,[n]
    mov qword   [k],1
    fld1
    fstp    qword   [prevElement]
    mov qword   [sum],0
sigma:
    fld     qword   [prevElement]
    fmul    qword   [x]
    fidiv   dword   [k]
    fst     qword   [prevElement]
    fadd    qword   [sum]
    fstp    qword   [sum]

    inc qword   [k]
    loop    sigma
    ret