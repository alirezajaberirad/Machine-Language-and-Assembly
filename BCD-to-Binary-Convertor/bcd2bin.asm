section .data
    d1 dw 0
    d2 dw 0
    userMsg db  'Enter a number with 3 digits: '
    lenUserMsg  equ  $-userMsg
    newLineC    db  0xA,0xD




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
dispMsg:
    mov rax,1
    mov rdi,1
    mov rsi,userMsg
    mov rdx,lenUserMsg
    syscall
    ret

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

readNum:
    mov     bl,0
    push    rdx
    mov     rdx,0

rAgain:
    xor     rax,rax
    call    getc
    cmp     al, 0x0A
    je      rEnd
    sub     al,0x30 ;the character minus the ascii code of 0
    shl     rbx,4   ;we shift the register value 4 bits, it is equivalent to a hex digit
    or     bl,al
    jmp     rAgain

rEnd:
    pop     rdx
    mov     rax,rbx
    ret


dispNum:
    push rax
    mov rax,1
    mov rdi,1
    mov rsi,rsp
    mov rdx,3
    syscall
    pop rax
    ret


BCD2BIN:
    mov bx,ax       ;the input copies to bx
    and ax,0x00F0   ;keeps the second digit of our input in ax lets call it deci
    shr ax, 1       ;ax is divided by 2 and saved in ax
    mov cx,ax       ;moving ax to cx
    shr ax,2        ;dividing ax by 4 and deci/8 will be stored in ax
    add ax,cx       ;adds deci/2 and deci/8 and stores it in ax
    mov [d1],ax     ;moving deci/2+deci/8 to d1, now the second digit is in d1
    
    ;lets find the third digit
    mov ax,bx       ;now the initial BCD is back again to ax
    and ax,0x0F00   ;stores the third digit of the BCD input in ax, lets call it huns
    shr ax,2        ;huns/4 is stored in ax
    mov cx,ax       ;huns/4 is stored in cx (256x/4= 64x)
    shr ax,1        ;huns/8 is stored in ax
    mov dx,ax       ;huns/8 is stored in dx (256x/8= 32x)
    shr ax,3        ;huns/64 is stored in ax
    mov [d2],ax     ;huns/64 is stored in d2 (256x/64= 4x)
    add [d2],dx     ;huns/64+huns/8 is in d2 (4x+32x= 36x)
    add [d2],cx     ;huns/64+huns/8+huns/4 is stored in d2 (36x+64x= 100x)
   
    ;the hundreds is stored in d2 and the decimals is stored in d1 and the initial input is in bx 
    ;lets construct the given number
    and bx,0x000F   ;the first digit of input is bx
    add bx,[d2]   ;hundreds+first digit is stored in bx
    add bx,[d1]     ;the final result is now in bx
    mov rax,rbx
    ret

Bin2BCD:
    mov bx,10
    mov rcx,0
    mov rdx,0
    div bx
    mov cl,dl
    add cl,0x30
    mov ah,0
    div bl
    add ah,0x30
    mov dl,al
    add dl,0x30
    mov al,0
    shl rcx,16
    or  rax,rdx
    or  rax,rcx
ret

_start:
    call dispMsg
    call readNum
    call BCD2BIN
    call Bin2BCD
    call dispNum
    ;Exit code
    call newLine
    mov rax,60
    mov rdi,0
    syscall


