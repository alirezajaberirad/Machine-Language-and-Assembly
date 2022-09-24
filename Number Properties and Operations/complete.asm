section .data
    userMsg db  'Enter a number: '
    lenUserMsg  equ $-userMsg
    isCompleteMsg   db  'The entered number is complete!'
    lenIsCompleteMsg    equ     $-isCompleteMsg
    notCompleteMsg   db  'The entered number is not complete.'
    lenNotCompleteMsg    equ     $-notCompleteMsg

section .text
    global  _start

_start:
    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the user massage

    call    readNum
    mov     rcx,rax
    xor     rdx,rdx
    call    Complete

    mov     rax,60
    mov     rbx,0
    syscall








;;;;;;;;;;;;Complete;;;;;;;;;;;;
Complete:
    mov     rbx,rcx
    call    Lfc
    cmp     r15,rax
    je      addIt   
continue:
    loop    Complete
    sub     rdx,rax ; I could have set rcx to rax-1 before calling Complete, but to satisfy the input 1 I have set rcx to start from rax in the loop. In this situation rdx have to be 2*rax to be a complete number.
    cmp     rdx,rax
    je      isComplete
    jne     notComplete
    ret


addIt:
    push    rax
    push    rbx
    push    rcx
    push    r15
    push    r8
    push    r9
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14

    add     rdx,rcx
    mov     rax,rcx
    call    writeNum
    call    newLine
    

    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9
    pop     r8
    pop     r15
    pop     rcx
    pop     rbx
    pop     rax
    jmp     continue

isComplete:
    push    rbx
    push    rcx
    push    rax
    push    rdx
    mov     rsi,isCompleteMsg
    mov     rdx,lenIsCompleteMsg
    mov     rax,1
    mov     rdi,1
    syscall
    call    newLine
    pop     rdx
    pop     rax
    pop     rcx
    pop     rbx
    ret

notComplete:
    mov     rsi,notCompleteMsg
    mov     rdx,lenNotCompleteMsg
    mov     rax,1
    mov     rdi,1
    syscall
    call    newLine
    ret

;;;;;;;;;;;;;;;LFC;;;;;;;;;;;;;;
;calculates Lfc of rax and rbx and stores it to r15
Lfc:
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
    
    mov     r15, 0
    call    gcd
    mul     rbx ;rax*rbx will be stored in rdx:rax
    div     r8  ;rdx:rax will be divided by gcd and stored in rax
    mov     r15, rax

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


gcd:
    push    rax
    push    rbx
    push    rcx
    push    rdx
    push    r15
    push    r9
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
again:
    xor     rdx,rdx
    cmp     rax,rbx
    ;if a is less than b then we swap a and b
    push    rcx
    cmovl   rcx,rax
    cmovl   rax,rbx
    cmovl   rbx,rcx
    pop     rcx
    
    xor     rdx,rdx ;the greater number is in rax, so for using div, we have to make rdx equal to zero, because rdx:rax will be divided by rbx
    div     rbx     ;rax is divided by rbx and the remaining is in rdx
    mov     rax,rbx 
    mov     rbx,rdx ;here we move the remaining to rbx
    cmp     rbx,0   ;if the remaining is zero, then the gcd is in rax and it has to be reported, else we have to do the procedure again
    jg      again

    mov     r8,rax      ;gcd of rax and rbx will be stored in r8


    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9
    pop     r15
    pop     rdx
    pop     rcx
    pop     rbx
    pop     rax
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