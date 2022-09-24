%include "in-out.asm"
section .data
    userMsg     db      'First enter n then m: '
    lenUserMsg  db      $-userMsg

section .bss
    n         resq  1
    m         resq  1
    result    resq  1

section .text
    global main

main:
    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rdi,1
    mov     rax,1
    syscall

    call    readNum
    mov     qword   [n],rax

    call    readNum
    mov     qword   [m],rax

    mov     qword   [result],0
    
    push    qword   [n]
    push    qword   [m]  
    push    qword   result
    call    choose

    mov     rax,[result]
    call    writeNum
    call    newLine

    mov     rax,60
    mov     rdi,0
    syscall

choose:
    enter   8,0
    mov     rbx,[rbp+32]
    mov     rcx,[rbp+24]
    cmp     rbx,rcx
    jge     recurse
    jl      isZero
go:

    mov     rax,[rbp+16]
    inc     qword   [rax]
    leave
    ret

isZero:
    leave
    ret

recurse:
    cmp     rcx,0
    jle      go
    dec     qword   [rbp+32]

    push    qword   [rbp+32]
    push    qword   [rbp+24]
    push    qword   [rbp+16]
    call    choose
    

    dec     qword   [rbp+24]

    push    qword   [rbp+32]
    push    qword   [rbp+24]
    push    qword   [rbp+16]
    call    choose

end:  
    leave
    ret

;runs correctly