%include "in-out.asm"
section .data
    userMsg     db  'Please enter a number: '
    lenUserMsg  equ $-userMsg

section .text
    global _start

_start:
    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the user massage

    call    readNum

    call    incnum

    call    writeNum
    call    newLine



    mov     rax,60
    mov     rbx,0
    syscall


incnum:
    bt  rax,0
    jc  negandset
    jnc set 
continue:
    ret

negandset:
    neg rax
    btr rax,0
    neg rax
    jmp continue

set:
    bts rax,0
    jmp continue

;runs correctly