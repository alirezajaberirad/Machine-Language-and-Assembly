%include "in-out.asm"
section .data
    userMsg     db  'Please enter a number: '
    lenUserMsg  equ $-userMsg
    dispMsg     db  'Reverse of the entered number is: '
    lenDispMsg  equ $-dispMsg

section .text
    global _start

_start:
    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the user massage

    call    readNum
    call    reverseDigits

    mov     rax,60
    mov     rbx,0
    syscall

reverseDigits:
    mov     rbx,10
    xor     r10,r10
    xor     rcx,rcx
divAgain:
    xor     rdx,rdx
    div     rbx
    add     r10,rdx
    inc     rcx
    push    rax
    mov     rax,r10
    mul     rbx
    mov     r10,rax
    pop     rax
    cmp     rax,0
    jne     divAgain

    mov     rax,r10
    div     rbx
    mov     rdx,rax
    push    rdx
    mov     rsi,dispMsg
    mov     rdx,lenDispMsg
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the result massage
    pop     rdx

    mov     rax,rdx
    call    writeNum
    call    newLine

    ret


;run correctly