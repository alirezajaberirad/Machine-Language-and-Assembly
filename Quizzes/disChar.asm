%include "in-out.asm"
section .data
    userMsg     db  'Please enter the string length: '
    lenUserMsg  equ $-userMsg

section .bss
    string     resb    100
    disString   resb    100

section .text
    global _start

_start:
    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the user massage

    call    readNum

    ;reading the input string
    push    rax
    mov     rdx,rax
    mov     rax,0
    mov     rdi,0
    mov     rsi,string
    syscall
    pop     rcx
    
    push    rcx
    call    convertToLow
    pop     rcx

    call    disChar

    call    writeResult

    call    newLine



    mov     rax,60
    mov     rbx,0
    syscall



convertToLow:
    mov     rsi,string

repeat:
    xor     rax,rax
    mov     al,[rsi]
    cmp     rax,'A'
    jge     toLow
continueToLow:
    add     rsi,1
    loop    repeat
    ret


toLow:
    cmp     rax,'Z'
    jg      back
    mov     rbx,'a'
    sub     rbx,'A'
    add     rax,rbx
    mov     [rsi],al
back:
    jmp     continueToLow





disChar:
    mov     rdi,disString
    mov     rsi,string
    mov     al,[rsi]
    mov     [rdi],al
    mov     rdx,1
hello:
    push    rcx
    mov     rcx,rdx
    jmp     checkChar
continueChecking:
    pop     rcx
    inc     rsi
    mov     rdi,disString
    loop    hello
    ret


checkChar:
    cmp  byte   [rsi],32
    je      endCheck
checkCharAgain:
    mov     al,[rdi]
    cmp     al,[rsi]
    je      endCheck
    inc     rdi 
    loop    checkCharAgain
    inc     rdx
    mov     al,[rsi]
    mov     [rdi],al
endCheck:
    jmp     continueChecking












writeResult:
    mov     rcx,rdx
    push    rcx
    xor     rax,rax
    mov     rsi,disString
    mov     al,[rsi]
    call    putc
    pop rcx
    dec rcx
    cmp rcx,0
    je  endResult
continueWrite:
    mov     rax,','
    call    putc
    mov     rax,32
    call    putc
    inc     rsi
    xor     rax,rax
    mov     al,[rsi]
    call    putc
    loop    continueWrite
endResult:
    ret


;runs correctly