%include "in-out.asm"
section .data
    userMsgRdx     db  'Enter a number that you wanted it to be stored in most significant bits(rdx): '
    lenUserMsgRdx  equ $-userMsgRdx
    userMsgRax     db  'Enter a number that you wanted it to be stored in least significant bits(rax): '
    lenUserMsgRax  equ $-userMsgRax
    dispMsgR8     db  'Decimal form of the reversed rax is: '
    lenDispMsgR8  equ $-dispMsgR8
    dispMsgR9     db  'Decimal form of the reversed rdx is: '
    lenDispMsgR9  equ $-dispMsgR9

section .text
    global _start

_start:
    mov     rsi,userMsgRdx
    mov     rdx,lenUserMsgRdx
    mov     rax,1
    mov     rdi,1
    syscall 

    call    readNum ;capturing rdx
    push    rax     ;pushing the input that has to be in rdx to stack

    mov     rsi,userMsgRax
    mov     rdx,lenUserMsgRax
    mov     rax,1
    mov     rdi,1
    syscall 

    call    readNum ;capturing rax
    pop     rdx

break1:

    call    reverseBitsRax
    call    reverseBitsRdx

break2:

    mov     rax,60
    mov     rbx,0
    syscall

reverseBitsRax: ;rax will be reversed and stored in r8
    push    r9
    push    rdx
    mov     rbx,2
    xor     r10,r10
    mov     rcx,64
divAgainRax:
    xor     rdx,rdx
    div     rbx
    add     r10,rdx
    push    rax
    mov     rax,r10
    mul     rbx
    mov     r10,rax
    pop     rax
    loop    divAgainRax

    mov     rax,r10
    div     rbx
    mov     rdx,rax
    push    rdx
    mov     rsi,dispMsgR8
    mov     rdx,lenDispMsgR8
    mov     rax,1
    mov     rdi,1
    syscall
    pop     rdx

    mov     rax,rdx
    mov     r8,rax
    call    writeNum
    call    newLine
    pop     rdx
    pop     r9

    ret




reverseBitsRdx: ;rdx will be reversed and stored in r9
    push    r8
    push    rax
    mov     rbx,2
    xor     r10,r10
    mov     rcx,64
    mov     rax,rdx
divAgainRdx:
    xor     rdx,rdx
    div     rbx
    add     r10,rdx
    push    rax
    mov     rax,r10
    mul     rbx
    mov     r10,rax
    pop     rax
    loop    divAgainRdx

    mov     rax,r10
    div     rbx
    mov     rdx,rax
    push    rdx
    mov     rsi,dispMsgR9
    mov     rdx,lenDispMsgR9
    mov     rax,1
    mov     rdi,1
    syscall 
    pop     rdx

    mov     rax,rdx
    mov     r9,rax
    call    writeNum
    call    newLine
    pop     rax
    pop     r8

    ret


;run correctly