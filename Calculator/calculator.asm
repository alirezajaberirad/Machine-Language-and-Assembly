%include "in-out.asm"
section .data
    userMsg db  "Please enter a mathematical expression: "
    lenUserMsg equ  $-userMsg

section .bss
    expression  resb    50

section .text
    global  _start

_start:             ;This program supports parantheses
    mov rsi,userMsg
    mov rdx,lenUserMsg
    mov rax,1
    mov rdi,1
    syscall

    call    calculator

    mov rax,60
    mov rbx,0
    syscall

calculator:
    mov rsi,expression
    mov rdx,50
    mov rax,0
    mov rdi,0
    syscall
    mov r8,rax
    dec r8
    jmp firstTime
again:
    push    rax
    mov rsi,expression
    mov rdx,50
    mov rax,0
    mov rdi,0
    syscall
    mov r8,rax
    dec r8
    pop     rax
    cmp byte [rsi],'$'
    je  endOfProgram
    call    infToPost
    call    calc
    call    writeNum
    call    newLine
    jmp     again


 firstTime:   
    cmp byte [rsi],'$'
    je  endOfProgram
    


    call    infToPost
    call    calculate
    call    writeNum
    call    newLine
    jmp     again
endOfProgram:
    ret

calc:
    push    rax
calculate:
    mov     rsi,expression
    mov     rcx,r8
continueCalculating:
    cmp rcx,0
    je  endCalculation
    cmp  byte   [rsi],'0'
    jl  operate
    xor rax,rax
    mov al,[rsi]
    sub rax,'0'
    push    rax
    inc rsi
    loop continueCalculating
endCalculation:
    pop rax
    ret

operate:
    cmp byte  [rsi],'*'
    je  multiply
    cmp byte  [rsi],'/'
    je  divide
    cmp byte  [rsi],'+'
    je  addThem
    cmp byte  [rsi],'-'
    je  subThem

multiply:
    pop rbx
    pop rax
    mul rbx
    push   rax
    dec rcx
    inc rsi
    jmp continueCalculating

divide:
    pop rbx
    pop rax
    xor rdx,rdx
    div rbx
    push   rax
    dec rcx
    inc rsi
    jmp continueCalculating

addThem:
    pop rbx
    pop rax
    add rax,rbx
    push   rax
    dec rcx
    inc rsi
    jmp continueCalculating

subThem:
    pop rbx
    pop rax
    sub rax,rbx
    push   rax
    dec rcx
    inc rsi
    jmp continueCalculating





infToPost:
    push    rax
    mov rsi,expression
    mov rdi,expression
    mov rcx,r8
toPostAgain:
    cmp rcx,0
    je  checkStack
    cmp byte [rsi],'0'
    jl  isOperator
    CLD
    movsb
    loop    toPostAgain
checkStack:
    jmp     freeStackToPost
endToPost:
    pop rax
    ret
isOperator:
    cmp byte [rsi],')'
    je  closePar
    cmp byte [rsi],'('
    je  openPar
    cmp byte [rsi],'*'
    je  isMultOrDiv
    cmp byte [rsi],'/'
    je  isMultOrDiv
    cmp byte [rsi],'+'
    je  isAddOrSub
    cmp byte [rsi],'-'
    je  isAddOrSub

    




closePar:
    dec rcx
    dec r8
    inc rsi
popAgain:
    pop rax
    cmp rax,'('
    je  toPostAgain
    CLD
    stosb
    jmp popAgain

openPar:
    dec     r8
    xor     rax,rax
    mov     al,[rsi]
    push    rax
    dec     rcx
    inc     rsi
    jmp     toPostAgain

isMultOrDiv:
    cmp  byte   [rsp],'*'
    je      popStackToPostMOD
    cmp  byte   [rsp],'/'
    je      popStackToPostMOD
    xor     rax,rax
    mov     al,[rsi]
    push    rax
    inc     rsi
    dec     rcx
    jmp     toPostAgain

popStackToPostMOD:
    pop     rax
    CLD
    stosb
    jmp     isMultOrDiv



isAddOrSub:
    cmp  byte   [rsp],'*'
    je      popStackToPostAOS
    cmp   byte  [rsp],'/'
    je      popStackToPostAOS
    cmp   byte  [rsp],'+'
    je      popStackToPostAOS
    cmp   byte  [rsp],'-'
    je      popStackToPostAOS
    xor     rax,rax
    mov     al,[rsi]
    push    rax
    inc     rsi
    dec     rcx
    jmp     toPostAgain

popStackToPostAOS:
    pop     rax
    CLD
    stosb
    jmp     isAddOrSub    


freeStackToPost:
    cmp  byte   [rsp],'*'
    je      popStackToPost
    cmp   byte  [rsp],'/'
    je      popStackToPost
    cmp   byte  [rsp],'+'
    je      popStackToPost
    cmp   byte  [rsp],'-'
    je      popStackToPost
    jmp     endToPost

popStackToPost:
    pop     rax
    CLD
    stosb
    jmp     freeStackToPost    
