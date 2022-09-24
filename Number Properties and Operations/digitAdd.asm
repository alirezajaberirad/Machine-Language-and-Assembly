section .data
    userMsg     db  'Please enter a number: '
    lenUserMsg  equ $-userMsg
    dispMsg     db  'Addition of the entered number is: '
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
    call    addDigits

    mov     rax,60
    mov     rbx,0
    syscall

addDigits:
    mov     rbx,10
    xor     r10,r10
addAgain:
    xor     rdx,rdx
    div     rbx
    add     r10,rdx
    cmp     rax,0
    jne     addAgain
    mov     rdx,r10
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


;;;;;;;;;;;;;;;Write Number and Read Number;;;;;;;;;;;;;;;;;
;The below codes are mostly like the provided code by Professor Nowzari, but it is not exactly the same!

;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;
newLine:
    push    rax
    mov     rax, 0x0A
    call    putc
    pop     rax
    ret

;;;;;;;;;;;;;;;;;;;;

putc:
    push    rbx
    push    rcx
    push    rsi
    push    rdx
    push    rdi
    push    rax
    mov     rsi,rsp
    mov     rdx,1
    mov     rax,1
    mov     rdi,1
    syscall
    pop     rax
    pop     rdi
    pop     rdx
    pop     rsi
    pop     rcx
    pop     rbx
    ret

;;;;;;;;;;;;;;;;;;;;

writeNum:
    push    rax
    push    rbx
    push    rcx
    push    rdx
    push    r8
    push    r9
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
    push    r15

    sub     rdx,rdx
    mov     rbx,10
    sub     rcx,rcx
    cmp     rax,0
    jge     wAgain  ;if it is not negetive number, start printing it
    push    rax
    mov     al,'-'
    call    putc
    pop     rax
    neg     rax

wAgain:
    cmp     rax,9
    jle     cEnd    ;ta ghabl az akharin ragham ro varede stack mikone
    div     rbx
    push    rdx
    inc     rcx
    sub     rdx,rdx
    jmp     wAgain

cEnd:
    add     al,0x30
    call    putc
    dec     rcx
    jl      wEnd
    pop     rax
    jmp     cEnd

wEnd:
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9
    pop     r8
    pop     rdx
    pop     rcx
    pop     rbx
    pop     rax
    ret

;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;
getc:
    push    rsi
    push    rdx
    push    rdi
    sub     rsp,1
    mov     rsi,rsp
    mov     rdx,1
    mov     rax,0
    mov     rdi,0
    syscall
    mov     al,[rsi]
    add     rsp,1
    pop     rdi
    pop     rdx
    pop     rsi

    ret
;;;;;;;;;;;;;;;;;;;;;;;;;

readNum:
    mov     bl,0
    push    rdx
    mov     rdx,0

rAgain:
    xor     rax,rax
    call    getc
    cmp     al,'-'
    jne     sAgain
    mov     bl,1
    jmp     rAgain

sAgain:
    cmp     al,0x0A
    je      rEnd 
    sub     rax,0x30
    imul    rdx,10
    add     rdx,rax
    xor     rax,rax
    call    getc
    jmp     sAgain

rEnd:
    mov     rax,rdx
    cmp     bl,0
    je      sEnd
    neg     rax

sEnd:  
    pop     rdx
    ret

;;;;;;;;;;;;;;;;;;;;;;