%include "in-out.asm"
section .data
    userMsg db  "First, tell me how many numbers you want to enter then enter the numbers respectively: "
    lenUserMsg  equ $-userMsg
section .bss
    arr     resq    100
    arrLen  resq    1
section .text
    global  _start

_start:

    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rax,1
    mov     rbx,1
    syscall

    call    getInput


    push    arr         ;high index
    push    0           ;low index
    push  qword  [arrLen]
    call    quickSort
    
    
    call    print

    mov     rax,60
    mov     rbx,0
    syscall


getInput:
    call    readNum
    mov     rcx,rax
    mov     rsi,arr
    mov     [arrLen],rcx
    dec  qword   [arrLen]
continueGettingInputs:
    call    readNum
    mov     [rsi],rax
    add     rsi,8
    loop continueGettingInputs
    ret

quickSort:
    enter   8,0
    mov     rbx,[rbp+24]    ;rbx=low
    cmp     rbx,[rbp+16]    ;if(low<high)
    jl      continueSort    ;if true
    leave         ;if false
    ret
continueSort:
    lea     rax,[rbp-8]
    push   rax  
    push   qword [rbp+32]
    push   qword [rbp+24]
    push   qword [rbp+16]
    call    partition ;the partition index is stored in r8



    mov     rax,[rbp-8];partition point is now in rax
    dec     rax ;in order to access the left side of the partition point
    push   qword [rbp+32]
    push   qword [rbp+24]
    push    rax
    call    quickSort

    mov     rax,[rbp-8]
    inc     rax ;in order to access the right side of the partition point
    push   qword [rbp+32]
    push    rax
    push   qword [rbp+16]
    call    quickSort
    leave
    ret 

partition:
    enter   24,0 ;three variables, one for pivot, one for "i" index and one for "j" index
    mov     rbx,[rbp+32] ;address of the start point of arr is in rbx
    mov     rcx,[rbp+16] ;value of "high" index is in rcx
    mov     rax,[rbx+rcx*8] ;times 8 because the array element size is quad word
    mov     [rbp-8],rax ;pivot is in rbp-8

    
    mov     rbx,[rbp+24]
    lea     rax,[rbx-1]
    mov     [rbp-16],rax ;low-1 is stored in rbp-16 as index i

    mov     rax,[rbp+24]
    dec     rax             ;j-- because after entering the loop j ([rbp-24]) will increase
    mov     [rbp-24],rax ;[rbp-24] acts like counter j in the loop
    
    mov     rax,[rbp+16]

continuePartition:   
    inc   qword  [rbp-24] ;j++

    mov     rax,[rbp-24]
    cmp     rax,[rbp+16]    ;if j<high continue looping
    jge     swap
    mov     rbx,[rbp+32]    ;arr
    mov     rcx,[rbp-24]    ;j
    mov     rax,[rbx+rcx*8] ;now rbx is equal to arr[j]
    cmp     rax,[rbp-8]     ; if(arr[j]<pivot)
    jge     continuePartition ;if false
    inc    qword [rbp-16]          ;if true


;;swap arr[i] and arr[j]

    mov     rbx,[rbp+32]    ;arr
    mov     rcx,[rbp-16]    ;i
    mov     rax,[rbx+rcx*8] ;rax=arr[i]
    mov     r8,rax          ;r8=arr[i]
    
    mov     rbx,[rbp+32]    ;arr
    mov     rcx,[rbp-24]    ;j
    mov     rax,[rbx+rcx*8] ;rax=arr[j]
    mov     r9,rax          ;r9=arr[j]

    mov     rbx,[rbp+32]
    mov     rcx,[rbp-16]
    mov     [rbx+rcx*8],r9  ;arr[i]=arr[j]


    mov     rbx,[rbp+32]
    mov     rcx,[rbp-24]
    mov     [rbx+rcx*8],r8  ;arr[j]=arr[i]
    jmp     continuePartition
swap:   ;swap arr[i+1] and arr[high]
    mov     rbx,[rbp+32]
    mov     rcx,[rbp-16]
    inc     rcx
    mov     rax,[rbx+rcx*8] ;arr[i+1]
    mov     r8,rax          ;r8=a[i+1]

    mov     rbx,[rbp+32]
    mov     rcx,[rbp+16]
    mov     rax,[rbx+rcx*8]
    mov     r9,rax          ;r9=a[high]

    mov     rbx,[rbp+32]
    mov     rcx,[rbp-16]
    inc     rcx
    mov     [rbx+rcx*8],r9

    mov     rbx,[rbp+32]
    mov     rcx,[rbp+16]
    mov     [rbx+rcx*8],r8


    mov     rcx,[rbp-16] ;pi=i+1
    inc     rcx
    mov     rbx,[rbp+40]
    mov     [rbx],rcx

    leave
    ret


print:
    mov     rsi,arr
    mov     rcx,[arrLen]
    inc     rcx
continuePrint:
    mov rax,[rsi]
    add rsi,8
    call    writeNum
    cmp rcx,1
    jle endPrint
    mov rax,','
    call    putc
    loop continuePrint
endPrint:
    call    newLine
    ret