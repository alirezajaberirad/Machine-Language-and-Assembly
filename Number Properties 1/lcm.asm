section .data
    userMsg     db  'Please enter two numbers: '
    lenUserMsg  equ $-userMsg
    dispMsg     db  'Least common multiple of the inputs is: '
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
    push    rax ;we push the input to stack to store it
    call    readNum ;the second input is recorded in rax
    pop     rbx ;popping the first input that we pushed to stack to rbx

    call    Lfc
    
    push    rax ;because we want to change it to use it in system call
    mov     rsi,dispMsg
    mov     rdx,lenDispMsg
    mov     rax,1
    mov     rdi,1
    syscall ;Printing the result
    pop     rax
    
    call    writeNum
    call    newLine
    mov     rdx,rax ;as you can see in Lfc, the Lfc is stored in rax. here we move that to rdx only to satisfy the question's conditions

    mov     rax,60
    mov     rbx,0
    syscall


Lfc:
    call    gcd
    mul     rbx ;rax*rbx will be stored in rdx:rax
    div     r8  ;rdx:rax will be divided by gcd and stored in rax

    ret


gcd:
    push    rax ;We push rax and rbx, because we need them for multiplication in Lfc subroutine
    push    rbx
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


    pop rax
    pop rbx
    ret




























;The below codes were previously provided by Professor Nowzari, including writeNum and readNum subroutines(functions)

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
    push    rcx
    push    rsi
    push    rdx
    push    rdi
    push    ax
    mov     rsi,rsp
    mov     rdx,1
    mov     rax,1
    mov     rdi,1
    syscall
    pop     ax
    pop     rdi
    pop     rdx
    pop     rsi
    pop     rcx
    ret

;;;;;;;;;;;;;;;;;;;;

writeNum:
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
    inc     cx
    sub     rdx,rdx
    jmp     wAgain

cEnd:
    add     al,0x30
    call    putc
    dec     cx
    jl      wEnd
    pop     rax
    jmp     cEnd

wEnd:
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