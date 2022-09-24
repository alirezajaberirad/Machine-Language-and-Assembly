%include "in-out.asm"
section .data
    userMsg     db  'Please enter a number: '
    lenUserMsg  equ $-userMsg
    dispMsg     db  'Number of bits with value 1 is: '
    lenDispMsg  equ $-dispMsg

section .text
    global _start

_start:
    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rax,1
    mov     rdi,1
    syscall

    call    readNum
    call    countOnes

    mov     rax,60
    mov     rbx,0
    syscall

countOnes:
    mov     rcx,2
    xor     r10,r10
    xor     rbx,rbx
divAgain:
    xor     rdx,rdx
    div     rcx
    cmp     rdx,1
    je      increaseBl
continue:
    cmp     rax,0
    jne     divAgain

    push    rbx
    mov     rsi,dispMsg
    mov     rdx,lenDispMsg
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the result massage
    pop     rbx

    mov     rax,rbx
    call    writeNum
    call    newLine

    ret


increaseBl:
    inc     bl
    jmp     continue