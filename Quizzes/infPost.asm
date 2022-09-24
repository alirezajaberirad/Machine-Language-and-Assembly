section .data
    userMsg     db  'Please enter an infix expression: '
    lenUserMsg  equ $-userMsg

section .bss
    buffer  resb    30

section .text
    global _start

_start:
    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the user massage

    mov     rax,0
    mov     rdi,0
    mov     rsi,buffer
    mov     rdx,30 
    syscall;reading the exp.
    mov     r8,rax

    mov     rsi,buffer
    mov     rcx,r8
    dec     rsi
    call intoPost

    mov     rsi,buffer
    mov     rdx,r8
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the final result

    mov     rax,60
    mov     rbx,0
    syscall

intoPost:
    inc rsi
    cmp byte [rsi],'+'
    je  swap
    

    cmp byte [rsi],'-'
    je  swap

    cmp byte [rsi],'*'
    je  swap

    cmp byte [rsi],'/'
    je  swap
    loop    intoPost
    jmp end

swap:
    mov   al,[rsi]
    mov   bl,[rsi+1]
    mov   [rsi],bl
    mov   [rsi+1],al
    inc     rsi
    jmp    intoPost

end:
    ret


;runs correctly
