%include "in-out.asm"
%include "sys-equal.asm"

section .data
    error_memAlloc  db  "error in allocation memory", NL, 0
    error_memfree   db  "error in freeing memory", NL, 0

section .bss
    mem_size    resq    1
    n           resq    1
    startAdr    resq    1
    startList   resq    1

section .text
    global main

main:
    call    readNum
    mov     [n],rax
    mov     rbx,2
    mul     rbx
    mov     [mem_size],rax
    call    memalloc

    push    qword   [n]
    push    qword   [startAdr]
    call    getList

    push    qword   [startAdr]
    call    showList
    ; call    showReverseList

    call    memfree
    mov     rax,60
    mov     rdi,0
    syscall

; showReverseList:
;     mov     r10,[startAdr]
;     mov     rax,[startList]
;     mov     rbx,2
;     mul     rbx
;     mov     rsi,rax
; reverseAgain:


showList:
    enter   8,0
    mov     r10,[rbp+16]
    call    readNum
    mov     rbx,2
    mul     rbx
    mov     rsi,rax
    mov     [startList],rax
showRegularList:
    lea     rbx,[r10+rsi]
    xor     rax,rax
    mov     al,[rbx]
    call    writeNum
    mov     rax,' '
    call    putc
    cmp  byte   [r10+rsi+1],-1
    je      endShow
    xor     rax,rax
    mov     al,[rbx+1]
    mov     rbx,2
    mul     rbx
    mov     rsi,rax
    jmp     showRegularList
endShow:
    call    newLine
    leave
    ret


getList:
    enter   8,0
    mov     r11,[rbp+16];start address
    mov     r10,[rbp+24];num of element pairs
    xor     rsi,rsi;writing index
    mov     rcx,r10
listAgain:
    call    readNum
    lea     rbx,[r11+rsi]
    mov     [rbx],al

    inc     rsi
    call    readNum
    lea     rbx,[r11+rsi]
    mov     [rbx],al

    inc     rsi
    loop    listAgain
    leave
    ret

memalloc:
    mov     rax,12
    xor     rdi,rdi
    syscall
    mov     [startAdr],rax

    mov     rax,12
    mov     rdi,[startAdr]
    add     rdi,[mem_size]
    syscall
    ret

memfree:
    mov     rax,12
    mov     rdi,[startAdr]
    syscall
    ret

;runs correctly but is not complete