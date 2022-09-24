%include "in-out.asm"
section .data
    userMsg    db  'Warning! If you want to check the addresses that you will enter you have to delete line number 36 and line number 37.'
    lenUserMsg equ   $-userMsg
    userMsg0    db  'If not, It will set rsi to starting address of the first massage and rdi to starting adress of the second massage.'
    lenUserMsg0 equ $-userMsg0
    userMsg1     db  'Please enter starting address: '
    lenUserMsg1  equ $-userMsg1
    userMsg2     db  'Please enter ending address: '
    lenUserMsg2  equ $-userMsg2
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
    call    newLine
    mov     rsi,userMsg0
    mov     rdx,lenUserMsg0
    mov     rax,1
    mov     rdi,1
    syscall
    call    newLine



    mov     rsi,userMsg1
    mov     rdx,lenUserMsg1
    mov     rax,1
    mov     rdi,1
    syscall

    call    readNum
    mov     rsi,rax


    push    rsi
    mov     rsi,userMsg2
    mov     rdx,lenUserMsg2
    mov     rax,1
    mov     rdi,1
    syscall

    call    readNum
    mov     rdi,rax
    pop     rsi
    ;;;;;;;;;;;;;;;;;IMPORTANT!!!!!!!!!!!!!!!
    ;IF YOU WANT TO TEST YOUR ENTERED ADDRESS(and the address is valid) DELETE 2 LINES BELOW
    mov     rsi,userMsg1
    mov     rdi,userMsg2

    call    countOneM


    push    rax
    mov     rsi,dispMsg
    mov     rdx,lenDispMsg
    mov     rax,1
    mov     rdi,1
    syscall
    pop     rax

    call    writeNum
    call    newLine

    mov     rax,60
    mov     rbx,0
    syscall

countOneM:
    xor     rax,rax
countAgain:
    cmp     rsi,rdi
    jle     countOnes

    ret



countOnes:
    push    rax
    xor     rax,rax
    mov     al,[rsi]
    inc     rsi
    mov     rcx,2
    xor     rbx,rbx
divAgain:
    xor     rdx,rdx
    div     rcx
    cmp     rdx,1
    je      increaseBl
continue:
    cmp     rax,0
    jne     divAgain

    pop     rax
    add     rax,rbx

    jmp     countAgain


increaseBl:
    inc     bl
    jmp     continue