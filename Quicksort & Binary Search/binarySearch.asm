%include "in-out.asm"
section .data
    userMsg db  "First, tell me how many numbers are in the array then enter the array elements from low to high, after all enter the number that you are looking for: "
    lenUserMsg  equ $-userMsg
    found   db  "Found! Its location index is(indexing from 0): "
    lenFound    equ $-found
    notFound    db  "Not found!"
    lenNotFound equ $-notFound
section .bss
    arr     resq    100
    arrLen  resq    1
    x       resq    1
    index   resq    1

section .text
    global  _start

_start:

    mov     rsi,userMsg
    mov     rdx,lenUserMsg
    mov     rax,1
    mov     rbx,1
    syscall

    call    getInput


    push    index
    push    arr         ;high index
    push    0           ;low index
    push    qword   [arrLen]
    push    qword   [x] 
    call    binarySearch


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
    call    readNum
    mov     [x],rax
    ret

binarySearch:
    enter   8,0
    mov     rbx,[rbp+24]
    cmp     rbx,[rbp+32] ;if (r<l) the go to end
    jl      endNotFound

    ;mid=l+(r-l)/2
    mov     rax,[rbp+24]    ;r
    sub     rax,[rbp+32]    ;r-l
    mov     rbx,2
    xor     rdx,rdx
    div     rbx             ;(r-l)/2
    add     rax,[rbp+32]    ;l+(r-l)/2
    mov     [rbp-8],rax     ;mid=l+(r-l)/2

    ;if (arr[mid]==x) then return mid
    mov     rbx,[rbp+40]    ;rbx=arr
    mov     rcx,[rbp-8]     ;rcx=mid
    mov     rax,[rbx+rcx*8] ;rax=arr[mid]
    cmp     rax,[rbp+16]
    je      endFound 

    ;if (arr[mid]>x) then return binarySearch(arr,l,mid-1,x)
    jg      SearchDown

    ;else ---(arr[mid]<x)---
    ;return binarySearch(arr,mid+1,r,x)
    push    qword   [rbp+48]
    push    qword   [rbp+40]
    mov     rcx,[rbp-8]
    inc     rcx
    push    rcx
    push    qword   [rbp+24]
    push    qword   [rbp+16]
    call    binarySearch
    leave   
    ret

SearchDown:
    ;return binarySearch(arr,l,mid-1,x)
    push    qword   [rbp+48]
    push    qword   [rbp+40]
    push    qword   [rbp+32]
    mov     rcx,[rbp-8]
    dec     rcx
    push    rcx
    push    qword   [rbp+16]
    call    binarySearch
    leave   
    ret

endFound:
    mov     rbx,[rbp+48]
    mov     rbx,[rbx]
    mov     rbx,[rbp-8]

    mov     rsi,found
    mov     rdx,lenFound
    mov     rax,1
    mov     rbx,1
    syscall

    mov rax,[rbp-8]
    call    writeNum
    call    newLine
    leave
    ret

endNotFound:
    mov     rbx,[rbp+48]
    mov     qword  [rbx],-1

    mov     rsi,notFound
    mov     rdx,lenNotFound
    mov     rax,1
    mov     rbx,1
    syscall
    call    newLine

    leave
    ret

