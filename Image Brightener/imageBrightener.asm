%include "in-out.asm"
%include "sys-equal.asm"
; code ham be dorosti directory va file ha ro tashkhis midad
; va ham vaghti ba yek aks kar mikard dorost kar mikard
; ama vaghti in do bakhsh ro ba ham edgham kardam code irad peyda kard
; vagarna har kodoom az bakhsha joda joda dorost amal mikardan.
section .data
    ;fileNameSrc        db      "index.bmp",0
    ;fileNameDes        db      "newIndex.bmp",0
    FDsrc              dq      0
    FDdes              dq      0
    headerlen          equ     900
    sys_getdir         equ     217
    numberOfPixels     equ     20000000 ;maximum size of accepted files

    path        db      "./hello",0
    FD          dq      0
    bufferlen   equ     400

    error_create    db      "error in creating file       ",NL,0
    error_close     db      "error in closing file       ",NL,0
    error_write     db      "error in writing file       ",NL,0
    error_open      db      "error in opening file       ",NL,0
    error_append    db      "error in appending file       ",NL,0
    error_delete    db      "error in deleting file       ",NL,0
    error_read      db      "error in reading file       ",NL,0
    error_print     db      "error in printing file       ",NL,0
    error_seek      db      "error in seeking file       ",NL,0
    error_openDir   db      "error in opening directory files      ",NL,0
    error_getDir    db      "error in getting directory files      ",NL,0
    
    suces_create    db      "file created and opened for R/W",NL,0
    suces_close     db      "file closed",NL,0
    suces_write     db      "written to file",NL,0
    suces_open      db      "file opened for R/W",NL,0
    suces_openDir   db      "Directory opened for R/W",NL,0
    suces_append    db      "file opened for appending",NL,0
    suces_delete    db      "file deleted  ",NL,0
    suces_read      db      "reading file",NL,0
    suces_seek      db      "seeking file",NL,0


section .bss
    header      resb    headerlen
    seek        resq    1
    n           resq    1
    pixel       resq    1
    counter     resq    1
    flag        resq    1
    fakeBuf     resq    numberOfPixels
    size        resq    1

    fileNameSrc     resb    bufferlen
    fileNameDes     resb    bufferlen
    buffer      resb    bufferlen
    bufEnd      resq    1

section .text
    global main

main:
    ;getting lighting factor from user
    call    readNum
    mov     qword [flag],0
    cmp     rax,0
    jl      negate
continue:
    xor     rcx,rcx
    mov     cl,al
    mov     rax,rcx
    mov     rbx,256
    mul     rbx
    add     rax,rcx
    mul     rbx
    add     rax,rcx
    mul     rbx
    add     rax,rcx
    mov     [n],rax ;[n]=0000nnnn
    call    readDir


    mov rax,60
    mov rdi,0
    syscall

negate:
    mov     qword [flag],1
    neg     rax
    jmp     continue
    
readDir:
    mov     rdi,path
    call    openDir
    mov     [FD],rax
    
    mov     rdi,[FD]
    mov     rsi,buffer
    mov     rdx,bufferlen
    call    getDir
    mov     rdi,rsi
    add     rax,buffer
    mov     [bufEnd],rax

    xor     rax,rax
    mov     ax,[buffer+16]
    lea     rsi,[buffer+rax]
nextFile:
    mov     ax,[rsi+16]

    push    rsi
    push    rax
    add     rsi,19
    call    getFileName
    call    handlePicture
    mov     rax,1
    mov     rdi,1
    mov     rsi,fileNameDes
    mov     rdx,bufferlen
    syscall

    call    newLine
    pop     rax
    pop     rsi

    lea     rsi,[rsi+rax]
    cmp     rsi,[bufEnd]
    jl      nextFile

    ret

getFileName:
    mov     rdi,fileNameSrc
    push    rsi
insertSrcFileName:
    cld
    movsb
    cmp     byte [rsi],0
    jne     insertSrcFileName
    pop     rsi
    mov     rdi,fileNameDes
insertDstFileName:
    cld
    movsb
    cmp     byte [rsi],0
    jne     insertDstFileName
    add     byte [fileNameDes],20
    ret


handlePicture:
    ;open source file to read
    mov     rdi,fileNameSrc
    call    openFile
    mov     [FDsrc],rax
    call    newLine

    ;create destination file to write
    mov     rdi,fileNameDes
    call    createFile
    mov     [FDdes],rax

movPictureHeader:
    ;read source header
    mov     rdi,[FDsrc]
    mov     rsi,header
    mov     rdx,headerlen   ; read length
    call    readFile
    mov     rdi,rsi         ; start point of buffer

    ;write to destination file
    mov     rdi,[FDdes]
    mov     rsi,header
    mov     rdx,headerlen
    call    writeFile

    ;seek source file at offset
    mov     rdi,[FDsrc]
    mov     rsi, headerlen ; skip headerlen bytes
    mov     rdx,0    ; from begining
    call    seekFile

    ;seek destination file at offset
    mov     rdi,[FDdes]
    mov     rsi,headerlen
    mov     rdx,0
    call    seekFile
    
    mov     rbx,headerlen
    mov     [seek],rbx

    ;fake read
    mov     rdi,[FDsrc]
    mov     rsi,fakeBuf
    mov     rdx,numberOfPixels   ; read length
    call    readFile
    mov     rdi,rsi         ; start point of buffer


    mov     [counter],rax
processPixels:
    ;read one pixel
    mov     rdi,[FDsrc]
    mov     rsi,pixel
    mov     rdx,4
    call    readFile

    ; subroutine e blends moshkel saze
    ;calling the image processor function
    push    qword [n]
    push    qword [pixel]
    call    blends

    mov     [pixel],rax 


    ;write that pixel to destination file
    mov     rdi,[FDdes]
    mov     rsi,pixel
    mov     rdx,4
    call    writeFile

    ;seek source for 4 bytes
    mov     rdi,[FDsrc]
    mov     rsi,[seek]
    mov     rdx,0 ;from current position
    call    seekFile

    ;seek destination for 4 bytes
    mov     rdi,[FDdes]
    mov     rsi,[seek]
    mov     rdx,0 ;from current position
    call    seekFile

    add     qword [seek],4
    ; call    writeNum
    ; call    newLine
    dec     qword [counter]
    cmp     qword [counter],0
    jnz     processPixels

    ;close files
    mov     rdi,[FDsrc]
    call    closeFile

    mov     rdi,[FDdes]
    call    closeFile

    mov     rax,[pixel]

    ret


blends:
    enter 0,0
    movd        mm1,[rbp+16]     ;mm1 = 0 0 0 0 A R G B
    movd        mm2,[rbp+24]    ;mm2 = 0 0 0 0 n n n n
    mov         eax,[rbp+24]
    bsr         eax,eax
    cmp         qword [flag],1
    je          subtract
    ;Increasing the brightness
    pxor        mm5,mm5         ;mm5 = 0 0 0 0 0 0 0 0
    punpcklbw   mm1,mm5         ;mm1 = 0 A 0 R 0 G 0 B
    punpcklbw   mm2,mm5         ;mm2 = 0 n 0 n 0 n 0 n
    paddw       mm1,mm2         ;mm1 = 0 A+n 0 R+n 0 G+n 0 B+n
    packuswb    mm1,mm1
    xor         rax,rax
    movd        eax,mm1         ;eax = A+n R+n G+n B+n
    leave
    ret 16


subtract:;Decreasing the brightness
    pxor        mm5,mm5         ;mm5 = 0 0 0 0 0 0 0 0
    punpcklbw   mm1,mm5         ;mm1 = 0 A 0 R 0 G 0 B
    punpcklbw   mm2,mm5         ;mm2 = 0 n 0 n 0 n 0 n
    psubw       mm1,mm2
    packuswb    mm1,mm1
    xor         rax,rax
    movd        eax,mm1         ;eax = A+n B+n G+n B+n
    leave
    ret 16

    ;--------------------------------------------------------------------------

createFile:
;for using it, move file name to rdi
    mov     rax,sys_create
    mov     rsi,sys_IRUSR | sys_IWUSR
    syscall
    cmp     rax,-1
    jle     createError
    mov     rdi,suces_create
    push    rax
    call    printString
    pop     rax
    ret
createError:
    mov     rdi,error_create
    call    printString
    ret

;--------------------------------------------------------------------------

openFile:
;for using it, move file name to rdi
    mov     rax,sys_open
    mov     rsi,O_RDWR
    syscall
    cmp     rax,-1
    jle     openError
    mov     rsi,suces_open
    push    rax
    call    printString
    pop     rax
    ret
openError:
    mov     rdi,error_open
    call    printString
    ret

;--------------------------------------------------------------------------

openDir:
;for using it, move file name to rdi
    mov     rax,sys_open
    mov     rsi,0q400  |  0q200
    mov     rdx,sys_IRUSR | sys_IWUSR
    syscall
    cmp     rax,-1
    jle     openDirError
    mov     rdi,suces_openDir
    push    rax
    call    printString
    pop     rax
    ret
openDirError:
    mov     rdi,error_openDir
    call    printString
    ret

;--------------------------------------------------------------------------

appendFile:
;for using it, move file name to rdi
    mov     rax,sys_open
    mov     rsi,O_RDWR | O_APPEND
    syscall
    cmp     rax,-1
    jle     appendError
    mov     rdi,suces_append
    push    rax
    call    printString
    pop     rax
    ret
appendError:
    mov     rdi,error_append
    call    printString
    ret

;--------------------------------------------------------------------------

writeFile:
;for using it, move file descriptor to rdi and rsi:buffer and rdx:length
    mov     rax,sys_write
    syscall
    cmp     rax,-1
    jle     writeError
    mov     rdi,suces_write
    ;call    printString
    ret
writeError:
    mov     rdi,error_write
    call    printString
    ret

;--------------------------------------------------------------------------

readFile:
;for using it, move file descriptor to rdi and rsi:buffer and rdx:length
    mov     rax,sys_read
    syscall
    cmp     rax,-1
    jle     readError
    mov     byte    [rsi+rax],0
    mov     rdi,suces_read
    ;call    printString
    ret
readError:
    mov     rdi,error_read
    call    printString
    ret

;--------------------------------------------------------------------------

closeFile:
;for using it, move file descriptor to rdi
    mov     rax,sys_close
    syscall
    cmp     rax,-1
    jle     closeError
    mov     rdi,suces_close
    call    printString
    ret
closeError:
    mov     rdi,error_close
    call    printString
    ret

;--------------------------------------------------------------------------

deleteFile:
;for using it, move file name to rdi
    mov     rax,sys_unlink
    syscall
    cmp     rax,-1
    jle     deleteError
    mov     rdi,suces_delete
    call    printString
    ret
deleteError:
    mov     rdi,error_delete
    call    printString
    ret

;--------------------------------------------------------------------------

seekFile:
;rdi:file descriptor; rsi:offset ; rdx:nesbat be koja(ebteda ya mogheiate jari ya enteha)
    mov     rax,sys_lseek
    syscall
    cmp     rax,-1
    jle     seekError
    mov     rdi,suces_seek
    ;call    printString
    ret
seekError:
    mov     rdi,error_seek
    call    printString
    ret

;--------------------------------------------------------------------------

getDir:
    mov     rax,217
    syscall
    cmp     rax,-1
    jle     getDirError
    mov     byte    [rsi+rax],0
    ;mov     rdi,suces_read
    ;call    printString
    ret
getDirError:
    mov     rdi,error_getDir
    call    printString
    ret
