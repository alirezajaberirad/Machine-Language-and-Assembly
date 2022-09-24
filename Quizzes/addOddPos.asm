%include "in-out.asm"
section .data
    userMsg     db  'Please enter a number: '
    lenUserMsg  equ $-userMsg
    oddMsg     db  'Addition of odd digits of odd position is: '
    lenOddMsg  equ $-oddMsg

section .text
    global _start

_start:
    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the user massage

    call    readNum
    call    addEo
    call    showResult

    mov     rax,60
    mov     rbx,0
    syscall

;;;;;;;;;;;;;;;addEo;;;;;;;;;;;;;;
addEo:
    mov     r8,10
    mov     r9,2
    xor     r13,r13

addAgain:
    xor     rdx,rdx
    div     r8
    xor     rdx,rdx
    div     r8
    push    rax
    push    rdx
    mov     rax,rdx
    xor     rdx,rdx
    div     r9
    cmp     rdx,1
    je      odd
    jne     skip

continue:
    pop     rax
    cmp     rax,0
    jne     addAgain
    mov     rdx,r13
    ret

odd:
    pop     rdx
    add     r13,rdx
    jmp     continue

skip:
    pop     rdx
    jmp     continue




;;;;;;;;;;;;showResult;;;;;;;;;;;;
showResult:
    push    rdx
    mov     rsi,oddMsg
    mov     rdx,lenOddMsg
    mov     rax,1
    mov     rdi,1
    syscall
    pop     rdx
    mov     rax,rdx
    call    writeNum    ;showing the addition of the odd digits
    call    newLine

    ret







;RUNS CORRECTLY