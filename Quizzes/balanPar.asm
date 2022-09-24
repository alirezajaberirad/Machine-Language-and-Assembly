section .data
    userMsg     db  'Please enter a set of parantheses: '
    lenUserMsg  equ  $-userMsg
    balanceMsg     db  'Balanced'
    lenBalanceMsg  equ $-balanceMsg
    unbalanceMsg   db  'Unbalanced'
    lenUnbalanceMsg equ $-unbalanceMsg
    newLineC    db  0xA,0xD

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text
    global _start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
newLine:
    push    rax
    mov     ecx, newLineC
    mov     edx,2   ;toole reshte
    mov     eax,4   ;shomare systemcall
    mov     ebx,1   ;code chap rooye monitor
    int     80h
    pop     rax

    ret 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getc:
    push    rsi 
    push    rdx 
    push    rdi
    sub     rsp,1
    mov     rsi, rsp
    mov     rdx,1
    mov     rax,0
    mov     rdi,0
    syscall 
    mov     al,[rsi]
    add     rsp,1
    pop    rdi 
    pop    rdx 
    pop    rsi 

    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

readStr:
    mov     bl,0
    push    rdx
    mov     rdx,0

rAgain:
    xor     rax,rax
    call    getc
    cmp     al, 0x0A
    je      rEnd
    cmp     al, '('
    je      incCounter
    cmp     al, ')'
    je      decCounter
    jmp     rAgain

incCounter:
    inc     r8
    jmp     rAgain

decCounter:
    dec     r8
    cmp     r8,0
    jb      negFlag
    jmp     rAgain
negFlag:
    mov     r9,0
    jmp     rEnd
rEnd:
    pop     rdx
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_start:
    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rax,1
    mov     rdi,1
    syscall
    mov     r8,0
    mov     r9,1
    call    readStr

    xor     r8,0
    xor     r9,1
    add     r8,r9
    cmp     r8,0
    jne     unsuccess
    push    rax
    mov     rsi,balanceMsg
    mov     rdx,lenBalanceMsg
    mov     rax,1
    mov     rdi,1
    syscall

    pop    rax
    jmp    exit

unsuccess:
    push    rax
    mov     rsi,unbalanceMsg
    mov     rdx,lenUnbalanceMsg
    mov     rax,1
    mov     rdi,1
    syscall

    pop    rax

exit:
    call    newLine
    mov     rax,60    
    mov     rdi,0
    syscall

    ;compile mishe va dorost kar mikone