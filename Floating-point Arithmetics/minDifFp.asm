%include "in-out.asm"
extern  printf
extern  scanf

section .data
    userMsg db  'First enter number of float numbers then enter each of them:',0
    lenUserMsg equ  $-userMsg
    printFmt    db  '%s',NL,0
    scanFmt     db  "%lf",0
    fmt         db  "The numbers with least difference are: %lf , %f",NL,0
    sys_brk equ 12


section .bss
    current_break resq 1
    initial_break resq 1
    new_break     resq 1
    offset        resq 1
    arg1          resq 1
    arg2          resq 1
    curr1         resq 1
    curr2         resq 1
    minDif        resq 1
    currDif       resq 1
    prevDif       resq 1

section .text
    global main

main:
    call    printMsg    
    call    readNum
    mov     [offset],rax
;;;;;;;;;;;;shoroo rakhsise hafeze ba estefade az jabejaii break;;;;;;;;;;;
    mov rax,sys_brk
    xor rdi,rdi
    dec rdi
    syscall
    mov [current_break],rax
    mov [initial_break],rax

    mov rax,sys_brk
    mov rdi,[current_break]
    mov rbx,[offset]
    imul    rbx,rbx,8
    add rdi,rbx
    syscall
    mov [new_break],rax
;;;;;;;;;;;;etmame rakhsise hafeze ba estefade az jabejaii break;;;;;;;;;;;

    call    getInputs ;be tedade [offset] voroodi migire
    call    detectMins

    push    rbp
    mov     rdi,fmt
    movq    xmm0,[arg1]
    movq    xmm1,[arg2]
    mov     rax,2
    call    printf
    pop     rbp

;;;;;;;;;;;;free kardan ba estefade az jabejaii break be makane avalie;;;;;;;;;;;
    mov rax,sys_brk
    mov rdi,[initial_break]
    syscall

    mov rax,60
    mov rdi,0
    syscall
;;;;end

printMsg:
    push    rsi
    push    rbp
    mov     rdi,printFmt
    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rax,0
    call    printf
    pop     rbp
    pop     rsi
    ret


getInputs:
    mov rbx,0
    mov rcx,[offset]
getAgain:
    push    rbx
    push    rcx
    push    rbp
    push    rsi
    mov     rsi,[initial_break]
    add     rsi,rbx
    mov     rdi,scanFmt
    xor     rax,rax
    call    scanf
    pop     rsi
    pop     rbp
    pop     rcx
    pop     rbx
    add     rbx,8
    loop    getAgain
    ret


detectMins:
    mov rbx,0
    mov r8,[initial_break]
    mov r9,[r8]
    mov r10,[r8+8]
    mov [curr1],r9
    mov [curr2],r10
    mov [arg1],r9
    mov [arg2],r10
    fld   qword  [curr1] 
    fsub  qword  [curr2]
    fabs
    fstp  qword  [minDif]
detectAgainExt:
    lea rcx,[rbx+1]
    mov r8,[initial_break]
detectAgainInt:
    mov r9,[r8+rbx*8]
    mov r10,[r8+rcx*8]
    mov [curr1],r9
    mov [curr2],r10
    fld   qword  [curr1] 
    fsub  qword  [curr2]
    fabs

    fst  qword  [currDif]

    fld  qword   [minDif]

    fst  qword  [prevDif]

    fcomip  st0,st1
    ja     changeArgs
    fstp
retFromChangeArgs:
    inc rcx
    cmp qword rcx,[offset]
    jl  detectAgainInt
    inc rbx
    mov rax,[offset]
    dec rax
    cmp qword rbx,rax
    jl detectAgainExt
    ret

changeArgs:
    mov [arg1],r9
    mov [arg2],r10
    fstp  qword  [minDif]
    jmp retFromChangeArgs