%include "in-out.asm"
section .data
    userMsg     db  'Please enter a number: '
    lenUserMsg  equ $-userMsg
    dispMsgMax     db  'Maximum appearance: '
    lenDispMsgMax  equ $-dispMsgMax
    dispMsgMin     db  'Minimum appearance: '
    lenDispMsgMin  equ $-dispMsgMin

section .bss
    arr     resq    100

section .text
    global _start

_start:
    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the user massage

    call    readNum
    mov     rcx,rax
    mov     rsi,arr
    push    rcx
    call    getInputs
    pop     rcx
    mov     rsi,arr
    mov     rdi,arr
    call    find


    mov     rsi,dispMsgMax
    mov     rdx,lenDispMsgMax
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the user massage
    mov     rax,r8
    call    writeNum
    call    newLine
    

    mov     rsi,dispMsgMin
    mov     rdx,lenDispMsgMin
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the user massage
    mov     rax,r10
    call    writeNum
    call    newLine

    mov     rax,60
    mov     rbx,0
    syscall


getInputs:
    call readNum
    mov  [rsi],rax
    add  rsi,8
    loop getInputs
    ret

find:
    mov     r8,[rsi]    ;r8 stores the max number
    xor     r9,r9       ;number of appearance of the max number
    mov     r10,[rdi]   ;r10 stores the min number
    mov     r12,100     ;number of appearance of the min number
    mov     rdx,rcx
findAgain:
    mov     rdi,arr
    push    rcx
    push    rax
br:
    CLD
    xor     r13,r13
    mov     rcx,rdx
    call    searchOnce
    pop     rax
    pop     rcx
    loop    findAgain
    ret

searchOnce:
    mov     rax,[rsi]
    scasq   
    je      incApp
continue:
    loop    searchOnce
    cmp     r9,r13
    cmovl   r9,r13
    cmovl   r8,rax
    cmp     r12,r13
    cmovge  r12,r13
    cmovge  r10,rax
    add     rsi,8   
    ret


incApp:
    inc     r13
    jmp     continue

;runs correctly