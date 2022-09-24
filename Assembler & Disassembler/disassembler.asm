%include "in-out.asm"
section .data
;syscall 
    sys_read           equ       0
    sys_write          equ       1
    sys_open           equ       2
    sys_close          equ       3
    sys_lseek          equ       8
    sys_create         equ       85
    sys_unlink         equ       87
    sys_exit           equ       60
    
    stdin              equ       0
    stdout             equ       1
    stderr             equ       3
;access mode
    O_RDONLY           equ       0q000000
    O_WRONLY           equ       0q000001
    O_RDWR             equ       0q000002
    O_CREAT            equ       0q000100
    O_APPEND           equ       0q002000
;create permission mode
    sys_IRUSR          equ       0q400
    sys_IWUSR          equ       0q200
;user define constant
    NewLine            equ       0xA
    bufferlen          equ       256

    fileNameSrc        db    "input_dis.txt"
    FDsrc              dq        0  ;file descriptor
    
    fileNameDes        db    "810196438_dis.txt"
    FDdes              dq        0  ;file descriptor
    
    error_create       db    "error in creating file                  ", NewLine, 0
    error_close        db    "error in closing file                   ", NewLine, 0
    error_write        db    "error in writing file                   ", NewLine, 0
    error_open         db    "error in opening file                   ", NewLine, 0
    error_append       db    "error in appending file                 ", NewLine, 0
    error_delete       db    "error in deleting file                  ", NewLine, 0
    error_read         db    "error in reading file                   ", NewLine, 0
    error_print        db    "error in printing file                  ", NewLine, 0
    error_seek         db    "error in seeking file                   ", NewLine, 0
    
    suces_create       db    "file created and opened for R/W         ", NewLine, 0
    suces_close        db    "file closed                             ", NewLine, 0
    suces_write        db    "written to file                         ", NewLine, 0
    suces_open         db    "file opened for R/W                     ", NewLine, 0
    suces_append       db    "file opened for appending               ", NewLine, 0
    suces_delete       db    "file deleted                            ", NewLine, 0
    suces_read         db    "reading file                            ", NewLine, 0
    suces_seek         db    "seeking file                            ", NewLine, 0
    
    x                  dq    "x                                       ", NewLine, 0 
    y                  dq    "y                                       ", NewLine, 0
    z                  dq    "z                                       ", NewLine, 0
; instruction name
    ;instructions_name  db    "mov", "add", "adc", NewLine, 0
    
        
    ;space_character    db    " "    
    
; instruction opcode
    mov_opcode         db    0x81
    
; type of instruction
    type_of_instr      db    -1 ; rr:0, rm:1, ri:2
    

    
; registers
    all_registers      dq    'al', 'ax', 'eax', 'rax', \
                             'cl', 'cx', 'ecx', 'rcx', \
                             'dl', 'dx', 'edx', 'rdx', \
                             'bl', 'bx', 'ebx', 'rbx', \
                             'ah', 'sp', 'esp', 'rsp', \
                             'ch', 'bp', 'ebp', 'rbp', \
                             'dh', 'si', 'esi', 'rsi', \
                             'bh', 'di', 'edi', 'rdi', \
                             'r8b','r8w','r8d', 'r8',  \
                             'r9b','r9w','r9d', 'r9',  \
                             'r10b','r10w', 'r10d', 'r10', \
                             'r11b','r11w', 'r11d', 'r11', \
                             'r12b','r12w', 'r12d', 'r12', \
                             'r13b','r13w', 'r13d', 'r13', \
                             'r14b','r14w', 'r14d', 'r14', \
                             'r15b','r15w', 'r15d', 'r15', NewLine, 0
; opcode of each instruction
    ; instruction names
    instruction_names_table  dq    "mov", "add", "or", "adc", "sbb", "and", "sub", "xor", "cmp", "inc", "dec", \
                                   "test", "xchg", "xadd", "imul", "idiv", "bsf", "bsr", "stc", "clc", \
                                   "std", "cld", "jmp", "jcc", "jrcxz", "shl", \
                                   "shr", "neg", "not", "call", "ret", "syscall", "push", "pop", NewLine, 0
                                   
   
                               
                                                           
                                                                                       
                                                                                                                   
                                                                                                                                               
                              ;    rr     rm    r8:i8 reg   mr    m    al:i8  r16:i8
    opcode_table             db    0x88,  0x8a, 0xc6, 0x0, 0x88, 0x00, 0xc6,  0xc6, \
                                   0x00,  0x02, 0x80, 0x0, 0x00, 0x00, 0x04,  0x82, \
                                   0x08,  0x0a, 0x80, 0x1, 0x08, 0x00, 0x0c,  0x82, \
                                   0x10,  0x12, 0x80, 0x2, 0x10, 0x00, 0x14,  0x82, \
                                   0x18,  0x1a, 0x80, 0x3, 0x18, 0x00, 0x1c,  0x82, \
                                   0x20,  0x22, 0x80, 0x4, 0x20, 0x00, 0x24,  0x82, \
                                   0x28,  0x2a, 0x80, 0x5, 0x28, 0x00, 0x2c,  0x82, \
                                   0x30,  0x32, 0x80, 0x6, 0x30, 0x00, 0x34,  0x82, \
                                   0x38,  0x3a, 0x80, 0x7, 0x38, 0x00, 0x3c,  0x82, \
                                   0xfe,  0xfa, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xfe,  0xfa, 0x00, 0x1, 0x00, 0x00, 0x00,  0x00, \
                                   0x84,  0x84, 0xf0, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0x86,  0x86, 0x86, 0x0, 0x86, 0x86, 0x86,  0x86, \
                                   0xc0,  0xc0, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xaf,  0xaf, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xf6,  0xf6, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xf6,  0xf6, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xf6,  0xf6, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xf9,  0xf9, 0xf9, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xf8,  0xf8, 0xf8, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xfd,  0xfd, 0xfd, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xfc,  0xfc, 0xfc, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xf6,  0x00, 0x00, 0x4, 0x00, 0xff, 0x00,  0x00, \
                                   0xf6,  0xf6, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xe3,  0xe3, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xd0,  0xf6, 0x00, 0x4, 0xd2, 0x00, 0x00,  0x00, \
                                   0xd0,  0xf6, 0x00, 0x5, 0xd2, 0x00, 0x00,  0x00, \
                                   0xf6,  0xf6, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xf6,  0xf6, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xf6,  0xf6, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0xf6,  0xf6, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0x05,  0x05, 0x05, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0x00,  0x00, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, \
                                   0x00,  0x00, 0x00, 0x0, 0x00, 0x00, 0x00,  0x00, NewLine, 0

    opcode_table_width          dq    8
; opcode of each instruction for disassembler

    dis_instruction_names_table dq       "add", "or", "adc", "sbb", "and", "sub", "xor", "cmp", "mov", \
                                         "inc", "dec", "test", "stc", "clc", "std", "cld", "syscall", "ret" , NewLine, 0
    
    
                         ; r/m8:r8  u    r/r    u    r/m   u     r/m64  u    al/i   u    rax/i  u    r8:i8  u    r6:i6  u    r6:i8  u    reg   extra
   
    dis_opcode_table     db  0x00, 0x01, 0x01, 0x01, 0x02, 0x01, 0x03, 0x01, 0x04, 0x01, 0x05, 0x01, 0x80, 0x00, 0x81, 0x00, 0x82, 0x00, 0x00, 0x00, \
                             0x08, 0x01, 0x09, 0x01, 0x0a, 0x01, 0x0b, 0x01, 0x0c, 0x01, 0x0d, 0x01, 0x80, 0x00, 0x81, 0x00, 0x82, 0x00, 0x01, 0x00, \
                             0x10, 0x01, 0x11, 0x01, 0x12, 0x01, 0x13, 0x01, 0x14, 0x01, 0x15, 0x01, 0x80, 0x00, 0x81, 0x00, 0x82, 0x00, 0x02, 0x00, \
                             0x18, 0x01, 0x19, 0x01, 0x1a, 0x01, 0x1b, 0x01, 0x1c, 0x01, 0x1c, 0x01, 0x80, 0x00, 0x81, 0x00, 0x82, 0x00, 0x03, 0x00, \
                             0x20, 0x01, 0x21, 0x01, 0x22, 0x01, 0x23, 0x01, 0x24, 0x01, 0x25, 0x01, 0x80, 0x00, 0x81, 0x00, 0x82, 0x00, 0x04, 0x00, \
                             0x28, 0x01, 0x29, 0x01, 0x2a, 0x01, 0x2b, 0x01, 0x2c, 0x01, 0x2c, 0x01, 0x80, 0x00, 0x81, 0x00, 0x82, 0x00, 0x05, 0x00, \
                             0x30, 0x01, 0x31, 0x01, 0x32, 0x01, 0x33, 0x01, 0x34, 0x01, 0x35, 0x01, 0x80, 0x00, 0x81, 0x00, 0x82, 0x00, 0x06, 0x00, \
                             0x38, 0x01, 0x39, 0x01, 0x3a, 0x01, 0x3b, 0x01, 0x3c, 0x01, 0x3c, 0x01, 0x80, 0x00, 0x81, 0x00, 0x82, 0x00, 0x07, 0x00, \
                             0x88, 0x01, 0x89, 0x01, 0x8a, 0x01, 0x8b, 0x01, 0x8c, 0x01, 0x8d, 0x01, 0x80, 0x00, 0x81, 0x00, 0x82, 0x00, 0x00, 0x00, \
                             0xfe, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
                             0xfe, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
                             0x84, 0x00, 0x85, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa8, 0x00, 0xa9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
                             0xf9, 0x00, 0xf9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
                             0xf8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
                             0xfd, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
                             0xfc, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
                             0x0f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
                             0xc3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
                             NewLine, 0
                                         
                                         
    
    dis_opcode_table_width   dq     0x14                                       

                   
                                       
                                       
; type of each operand
    ;first_operand_type  db   0x0
    ;second_operand_type db   0x0
    aaaa db "abb"
    aaaalen equ $-aaaa
    bbbb db "rax"
    bbbblen equ $-bbbb
    
section .bss
    buffer                       resb         bufferlen
    input                        resb         256
    output                       resb         256
    set_zero                     resb         16
; different part of instruction
    instruction_name             resb         64
    operand_1                    resb         256
    operand_2                    resb         256
    
;type of instruction r:1, m:2, i:3
    first_operand_type           resb         16
    second_operand_type          resb         16

; mod rm code variables
    register1_code               resb         16
    register2_code               resb         16
    mod                          resb         16
    mod_rm_code                  resb         16
    register1_index              resb         16
    register2_index              resb         16
; register three for sib         
    register3_code               resb         16
    register3_index              resb         16
    
; opcode
    index_of_instruction_name    resb         16   ; 0 for rr, 1 for rm, 2 for ri
    opcode                       resb         16
    i_th_instruction             resb         16   ; location of instruction in instruction table
    opcode_0f_permission         resb         16
    opcode_0f                    resb         16
    
; prefix
    is_prefix                    resb         16
    prefix_operand               resb         16
    prefix_address               resb         16
    prefix_1_code                resb         16
    prefix_1_code_permission     resb         16
    prefix_2_code                resb         16
    prefix_2_code_permission     resb         16
    
; rex
    is_rex                       resb         16
    rex_code                     resb         16
    rex_w                        resb         16
    rex_r                        resb         16
    rex_x                        resb         16
    rex_b                        resb         16
    rex_o                        resb         16

; memory parts
    base                         resb         16
    base_len                     resb         16
    base_code                    resb         16
    base_index                   resb         16
    base_flag                    resb         16    ; show there is base in instruction
    scale                        resb         16
    scale_len                    resb         16
    sib_index                    resb         16
    sib_index_len                resb         16
    sib_index_code               resb         16
    sib_index_index              resb         16
    sib_index_flag               resb         16    ; show there is index in instruction
    displacement                 resb         64
    displacement_len             resb         16
    displacement_flag            resb         16    ; show there is displacement in instruction
    
    displacement_1               resb         16
    displacement_2               resb         16
    displacement_3               resb         16
    displacement_4               resb         16
    
    displacement_1_permission    resb         16
    displacement_2_permission    resb         16
    displacement_3_permission    resb         16
    displacement_4_permission    resb         16

    index_scale                  resb         16
    index_scale_len              resb         16
    memory_part1                 resb         64
    memory_part1_busy            resb         16
    memory_part2                 resb         64
    memory_part2_busy            resb         16
    memory_part3                 resb         64
    memory_part3_busy            resb         16
    memory_count_parts           resb         16
    sib_code                     resb         16
    sib_scale_size               resb         16
    
; register_immediate 
    register_immediate_reg       resb         16
    
; disassembler 
    dis_part1                    resb         16
    dis_part1_busy               resb         16
    dis_part2                    resb         16
    dis_part2_busy               resb         16
    dis_part3                    resb         16
    dis_part3_busy               resb         16
    dis_part4                    resb         16
    dis_part4_busy               resb         16
    dis_part5                    resb         16
    dis_part5_busy               resb         16
    dis_part6                    resb         16
    dis_part6_busy               resb         16
    dis_part7                    resb         16
    dis_part7_busy               resb         16
    
    dis_rex_code                 resb         16
    dis_rex_code_busy            resb         16
    dis_prefix_code66            resb         16
    dis_prefix_code66_busy       resb         16
    dis_prefix_code67            resb         16
    dis_prefix_code67_busy       resb         16
    dis_opcode                   resb         16
    dis_opcode_busy              resb         16
    dis_mod_rm_code              resb         16
    dis_mod_rm_busy              resb         16
    dis_sib_code                 resb         16
    dis_sib_code_busy            resb         16
    dis_displacement             resb         16
    dis_displacement_busy        resb         16

    dis_displacement4            resb         16
    dis_displacement4_busy       resb         16
    dis_displacement3            resb         16
    dis_displacement3_busy       resb         16
    dis_displacement2            resb         16
    dis_displacement2_busy       resb         16
    dis_displacement1            resb         16
    dis_displacement1_busy       resb         16
    
    dis_instruction_name         resb         16
    dis_instruction_index        resb         16       ; i'th instruction
    dis_instruction_len          resq         1

; disassembler mod rm code 
    dis_reg_checked              resb         16
    dis_rm_checked               resb         16
    dis_regop                    resb         16
    dis_rm                       resb         16
    dis_is_new_reg_check         resb         1
; permissions
    rex_code_permission          resb         16       ;is it allowed to be written in output
    prefix_code_permission       resb         16
    opcode_permission            resb         16
    mod_rm_code_permission       resb         16
    sib_code_permission          resb         16
    displacement_permission      resb         16
    
; write setting
    write_length                 resb         16
    
; length of operand
    operand_len                  resb         16
    
; type of instruction
    type_of_instruction          resb         16
    
section .text
    global main



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:
    mov rbp, rsp; for correct debugging
    mov rdi, fileNameSrc
    call openFile
    mov [FDsrc], rax
    
    mov rdi, fileNameDes
    call createFile
    mov [FDdes], rax
    
    ; seek source file at offset
    mov rdi, [FDsrc]
    mov rsi, 0 ; skip the 0 char
    mov rdx, 0
    call seekFile
    
    ; read from source file
    mov rdi, [FDsrc]
    mov rsi, input
    mov rdx, 256 ; read length
    call readFile
    mov rdi, rsi ; start of buffer
    call printString
    
    mov rsi, input
        loop1:
        call fill_buffer
        push rsi
        call flush_memories
        pop  rsi
        push rsi
        call determine_type_of_program
        call fill_output
        ; write to destination file
        mov r9, [write_length]
        inc r9
        mov rdi, [FDdes]
        mov rsi, output
        mov rdx, r9 ; write length
        call writeFile
        pop rsi
        inc rsi
        mov rax, [rsi]
        cmp al, 0
        je  endOfFile
        jmp loop1
 flush_memories:
    mov rdi,operand_1
    call    set_to_zero
    mov rdi,operand_2
    call    set_to_zero
    mov rdi,first_operand_type
    call    set_to_zero
    mov rdi,second_operand_type 
    call    set_to_zero
    mov rdi,register2_code  
    call    set_to_zero
    mov rdi,register1_index  
    call    set_to_zero
    mov rdi,register2_index
    call    set_to_zero
    mov rdi,mod_rm_code 
    call    set_to_zero
    mov rdi,mod
    call    set_to_zero
    mov rdi,rex_code
    call    set_to_zero
    mov rdi,rex_w 
    call    set_to_zero
    mov rdi,rex_r
    call    set_to_zero
    mov rdi,rex_x
    call    set_to_zero
    mov rdi,rex_b 
    call    set_to_zero
    
    mov rdi,base 
    call    set_to_zero
    mov rdi,base_len
    call    set_to_zero
    mov rdi,base_code
    call    set_to_zero
    mov rdi,base_index 
    call    set_to_zero
    mov rdi,base_flag 
    call    set_to_zero
    mov rdi,scale  
    call    set_to_zero
    mov rdi,scale_len
    call    set_to_zero

    mov rdi,sib_index
    call    set_to_zero
    mov rdi,sib_index_len 
    call    set_to_zero
    mov rdi,sib_index_code 
    call    set_to_zero
    mov rdi,sib_index_index
    call    set_to_zero
    mov rdi,sib_index_flag
    call    set_to_zero
    mov rdi,displacement
    call    set_to_zero
    mov rdi,displacement_len
    call    set_to_zero
    mov rdi,displacement_flag
    call    set_to_zero

    mov rdi,displacement_1 
    call    set_to_zero
    mov rdi,displacement_2
    call    set_to_zero
    mov rdi,displacement_3
    call    set_to_zero
    mov rdi,displacement_4 
    call    set_to_zero
    mov rdi,displacement_1_permission  
    call    set_to_zero
    mov rdi,displacement_2_permission 
    call    set_to_zero
    mov rdi,displacement_3_permission  
    call    set_to_zero
    mov rdi,displacement_4_permission 
    call    set_to_zero
    mov rdi,index_scale 
    call    set_to_zero
    mov rdi,index_scale_len
    call    set_to_zero
    mov rdi,memory_part1   
    call    set_to_zero
    mov rdi,memory_part1_busy  
    call    set_to_zero
    mov rdi,memory_part2       
    call    set_to_zero
    mov rdi,memory_part2_busy    
    call    set_to_zero
    mov rdi,memory_part3       
    call    set_to_zero
    mov rdi,memory_part3_busy  
    call    set_to_zero
    mov rdi,memory_count_parts
    call    set_to_zero
    mov rdi,sib_code   
    call    set_to_zero
    mov rdi,sib_scale_size
    call    set_to_zero
    mov rdi,register_immediate_reg 
    call    set_to_zero
    mov rdi,dis_part1  
    call    set_to_zero
    mov rdi,dis_part1_busy
    call    set_to_zero
    mov rdi,dis_part2   
    call    set_to_zero
    mov rdi,dis_part2_busy 
    call    set_to_zero
    mov rdi,dis_part3  
    call    set_to_zero
    mov rdi,dis_part3_busy   
    call    set_to_zero
    mov rdi,dis_part4    
    call    set_to_zero
    mov rdi,dis_part4_busy 
    call    set_to_zero
    mov rdi,dis_part5 
    call    set_to_zero
    mov rdi,dis_part5_busy 
    call    set_to_zero
    mov rdi,dis_part6 
    call    set_to_zero
    mov rdi,dis_part6_busy  
    call    set_to_zero
    mov rdi,dis_part7  
    call    set_to_zero
    mov rdi,dis_part7_busy
    call    set_to_zero
    mov rdi,dis_rex_code 
    call    set_to_zero
    mov rdi,dis_rex_code_busy
    call    set_to_zero
    mov rdi,dis_prefix_code66 
    call    set_to_zero
    mov rdi,dis_prefix_code66_busy 
    call    set_to_zero
    mov rdi,dis_prefix_code67 
    call    set_to_zero
    mov rdi,dis_prefix_code67_busy
    call    set_to_zero
    mov rdi,dis_opcode 
    call    set_to_zero
    mov rdi,dis_opcode_busy 
    call    set_to_zero
    mov rdi,dis_mod_rm_code 
    call    set_to_zero
    mov rdi,dis_mod_rm_busy  
    call    set_to_zero
    mov rdi,dis_sib_code   
    call    set_to_zero
    mov rdi,dis_sib_code_busy 
    call    set_to_zero
    mov rdi,dis_displacement  
    call    set_to_zero
    mov rdi,dis_displacement_busy
    call    set_to_zero
    mov rdi,dis_displacement4 
    call    set_to_zero
    mov rdi,dis_displacement4_busy   
    call    set_to_zero
    mov rdi,dis_displacement3    
    call    set_to_zero
    mov rdi,dis_displacement3_busy  
    call    set_to_zero
    mov rdi,dis_displacement2  
    call    set_to_zero
    mov rdi,dis_displacement2_busy 
    call    set_to_zero
    mov rdi,dis_displacement1 
    call    set_to_zero
    mov rdi,dis_displacement1_busy 
    call    set_to_zero
    mov rdi,dis_instruction_name 
    call    set_to_zero
    mov rdi,dis_instruction_index
    call    set_to_zero
    mov rdi,dis_instruction_len 
    call    set_to_zero
    mov rdi,dis_reg_checked 
    call    set_to_zero
    mov rdi,dis_rm_checked 
    call    set_to_zero
    mov rdi,dis_regop 
    call    set_to_zero
    mov rdi,dis_rm
    call    set_to_zero
    mov rdi,dis_is_new_reg_check 
    call    set_to_zero
    mov rdi,rex_code_permission 
    call    set_to_zero
    mov rdi,prefix_code_permission 
    call    set_to_zero
    mov rdi,opcode_permission 
    call    set_to_zero
    mov rdi,mod_rm_code_permission 
    call    set_to_zero
    mov rdi,sib_code_permission 
    call    set_to_zero
    mov rdi,displacement_permission
    call    set_to_zero
    mov rdi,write_length
    call    set_to_zero
    mov rdi,operand_len
    call    set_to_zero
    mov rdi,type_of_instruction 
    call    set_to_zero
 ret
set_to_zero:
    mov rsi,set_zero
    cld
    movsq
    movsq
    ret
 
 endOfFile:
    ; close files
    mov rdi, [FDsrc]
    call closeFile
    
    mov rdi, [FDdes]
    call closeFile
    
    mov     rax,60
    mov     rdi,0
    syscall
    ; delete file
    ;mov rdi, fileNameSrc
    ;call deleteFile
initialize_all_memory:
    xor rdi, rdi
    mov rcx, 0x181c
    initialize_all_memory_loop:
        cmp rcx, 0
        je initialize_all_memory_end
        xor rax, rax
        mov [buffer + rdi], rax
        inc rdi
        dec rcx
        jmp initialize_all_memory_loop
    initialize_all_memory_end:
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fill_buffer:
    xor rdi, rdi
    fill_buffer_loop:
        mov rax, [rsi]
        cmp al, 10
        je fill_buffer_end
        cmp al, 0 ;end of file
        je fill_buffer_end
        mov [buffer + rdi], al
        mov [x], al
        inc rsi
        inc rdi
        jmp fill_buffer_loop
    fill_buffer_end:
        mov [buffer+rdi], al
        ret

convert_hex_to_string:
    ; number stored in rax
    mov r10, rax
    mov r11, 16
    div r11
    xor rbx, rbx
    mov bx, ax
    xor rax, rax
    mov rax, rbx
    cmp ax, 0
    je convert_hex_to_string_one_bit
    call convert_hex_to_string_condition
    mov [rsi], al
    inc rsi
    inc r9
    mov r11, 0x0f
    and r10, r11
    mov rax, r10
    call convert_hex_to_string_condition
    mov [rsi], al
    inc rsi
    inc r9
    mov rax, '\'
    mov [rsi], rax
    inc rsi
    inc r9
    ret
    convert_hex_to_string_one_bit:
        mov rbx, '0'
        mov [rsi], rbx
        inc rsi
        inc r9
        cmp r10, 10
        jae convert_hex_to_string_one_bit_alphabet
        add r10, '0'
        mov [rsi], r10
        inc rsi
        inc r9
        mov rax, '\'
        mov [rsi], rax
        inc rsi
        inc r9
        ret 
        convert_hex_to_string_one_bit_alphabet:
            sub r10, 10
            add r10, 'a'
            mov [rsi], r10
            inc rsi
            inc r9
            mov rax, '\'
            mov [rsi], rax
            inc rsi
            inc r9
            ret
    convert_hex_to_string_condition:
        cmp rax, 10
        jae convert_hex_to_string_condition_alphabet
        add rax, '0'
        ret
        convert_hex_to_string_condition_alphabet:
            sub rax, 10
            add rax, 'a'
            ret        
    
    
fill_output:
    mov rsi, output
    xor r9, r9
    call fill_output_rex_code
    call fill_output_prefix_1_code
    call fill_output_prefix_2_code
    call fill_output_opcode_0f
    call fill_output_opcode
    call fill_output_mod_rm_code
    call fill_output_sib_code
    call fill_output_displacement_4
    call fill_output_displacement_3
    call fill_output_displacement_2
    call fill_output_displacement_1
    call fill_dis_output_opcode
    call fill_dis_output_rm
    call fill_dis_output_regop
    mov [write_length], r9
    mov rax, 10
    mov [rsi], rax
    ret
    
    fill_dis_output_rm:
        mov     rdi,rsi
        mov     rsi,dis_rm
        cmp     byte [rsi],0
        je      end_fill_dis_noop
    fill_dis_rm_loop:
        cmp     byte [rsi],0
        je      end_fill_dis_rm
        movsb
        inc     r9
        jmp     fill_dis_rm_loop
    end_fill_dis_rm:
        mov     byte[rdi],','
        inc     r9
        inc     rdi
    end_fill_dis_noop:
        mov     rsi,rdi
        ret

    fill_dis_output_regop:
        mov     rdi,rsi
        mov     rsi,dis_regop
    fill_dis_regop_loop:
        cmp     byte [rsi],0
        je      end_fill_dis_regop
        cmp     byte [mod],3
        jne      fill_dis_regop_indirectAddressing
        movsb
        inc     r9
        jmp     fill_dis_regop_loop
    end_fill_dis_regop:
        mov     rsi,rdi
        ret

    fill_dis_regop_indirectAddressing:
        mov     byte [rdi],'['
        inc     rdi
        inc     r9
    fill_dis_regop_indirectAddressing_loop:
        cmp     byte [rsi],0
        je      end_fill_dis_regop_indirectAddressing
        movsb
        inc     r9
        jmp     fill_dis_regop_indirectAddressing_loop
    end_fill_dis_regop_indirectAddressing:
        cmp     byte [dis_displacement4_busy],1
        jne     end_fill_with_bracket
        mov     byte [rdi],'+'
        inc     rdi
        inc     r9
        cmp     byte [dis_displacement1_busy],1
        jne     fill_dis_disp2
        mov     bl,[displacement_1]
        mov     [rdi],bl
        inc     rdi
        inc     r9
    fill_dis_disp2:
        cmp     byte [dis_displacement2_busy],1
        jne     fill_dis_disp3
        mov     bl,[displacement_2]
        mov     byte [rdi],bl
        inc     rdi
        inc     r9
    fill_dis_disp3:
        cmp     byte [dis_displacement3_busy],1
        jne     fill_dis_disp4
        mov     bl,[displacement_3]
        mov     byte [rdi],bl
        inc     rdi
        inc     r9
    fill_dis_disp4:
        cmp     byte [dis_displacement4_busy],1
        jne     fill_dis_disp4
        mov     bl,[displacement_4]
        mov     byte [rdi],bl
        inc     rdi
        inc     r9
    end_fill_with_bracket:
        mov     byte [rdi],']'
        inc     rdi
        inc     r9
        jmp     end_fill_dis_regop

    fill_dis_output_opcode:
        mov     rdi,rsi
        mov     rsi,dis_instruction_name
        mov     rcx,[dis_instruction_len]
    fill_dis_opcode_loop:
        movsb
        loop    fill_dis_opcode_loop
        mov     rsi,rdi
        add     r9,[dis_instruction_len]
        mov     byte [rsi],' '
        inc     rsi
        inc     r9
        call    newLine
        ret
    fill_output_rex_code:
        mov rbx, [rex_code_permission]
        cmp rbx, 1
        je fill_output_rex_code_write
        ret
        fill_output_rex_code_write:
                mov rax, [rex_code]
                call convert_hex_to_string
                ret
    fill_output_prefix_1_code:
        mov rbx, [prefix_1_code_permission]
        cmp rbx, 1
        je fill_output_prefix_1_code_write
        ret
        fill_output_prefix_1_code_write:
                mov rax, [prefix_1_code]
                call convert_hex_to_string
                ret
    fill_output_prefix_2_code:
        mov rbx, [prefix_2_code_permission]
        cmp rbx, 1
        je fill_output_prefix_2_code_write
        ret
        fill_output_prefix_2_code_write:
                mov rax, [prefix_2_code]
                call convert_hex_to_string
                ret
    fill_output_opcode_0f:
        mov rbx, [opcode_0f_permission]
        cmp rbx, 1
        je fill_output_opcode_0f_write
        ret
        fill_output_opcode_0f_write:
                mov rax, [opcode_0f]
                call convert_hex_to_string
                ret
    fill_output_opcode:
        mov rbx, [opcode_permission]
        cmp rbx, 1
        je fill_output_opcode_write
        ret
        fill_output_opcode_write:
                mov rax, [opcode]
                call convert_hex_to_string
                ret
    fill_output_mod_rm_code:
        mov rbx, [mod_rm_code_permission]
        cmp rbx, 1
        je fill_output_mod_rm_code_write
        ret
        fill_output_mod_rm_code_write:
                mov rax, [mod_rm_code]
                call convert_hex_to_string
                ret
    fill_output_sib_code:
        mov rbx, [sib_code_permission]
        cmp rbx, 1
        je fill_output_sib_code_write
        ret
        fill_output_sib_code_write:
                mov rax, [sib_code]
                call convert_hex_to_string
                ret
    fill_output_displacement_4:
        mov rbx, [displacement_4_permission]
        cmp rbx, 1
        je fill_output_displacement_4_write
        ret
        fill_output_displacement_4_write:
                mov rax, [displacement_4]
                call convert_hex_to_string
                ret 
    fill_output_displacement_3:
        mov rbx, [displacement_3_permission]
        cmp rbx, 1
        je fill_output_displacement_3_write
        ret
        fill_output_displacement_3_write:
                mov rax, [displacement_3]
                call convert_hex_to_string
                ret 
    fill_output_displacement_2:
        mov rbx, [displacement_2_permission]
        cmp rbx, 1
        je fill_output_displacement_2_write
        ret
        fill_output_displacement_2_write:
                mov rax, [displacement_2]
                call convert_hex_to_string
                ret 
    fill_output_displacement_1:
        mov rbx, [displacement_1_permission]
        cmp rbx, 1
        je fill_output_displacement_1_write
        ret
        fill_output_displacement_1_write:
                mov rax, [displacement_1]
                call convert_hex_to_string
                ret 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
determine_type_of_program:
    ; mov rsi, buffer
    ; mov rax, [rsi]
    ; cmp al, '\'
    jmp disassembler
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; for example: \x48\x39\xD8
disassembler:
    call disassembler_split
    call disassembler_find_instruction_name
    call disassembler_find_operands
    ret        


disassembler_split:
    mov rsi, buffer
    ; add rsi, 2
    mov r15, 16
    disassembler_split_part1:
        xor r14, r14
        xor rax, rax
        mov rax, [rsi]
        call convert_string_to_hex
        mul r15
        mov r14, rax
        add rsi, 1
        mov rax, [rsi]
        call convert_string_to_hex
        add r14, rax
        mov [dis_part1], r14b;masalan tooye \x48\x89\xD8 alan 0x48 be decimal tooye [dis_part1] save shode
        
        mov rax, [dis_part1]
        call disassembler_split_assign

        mov r13, [dis_part1]
        add rsi, 1
        mov rax, [rsi]
        ; cmp al, '\'
        ; je disassembler_split_part2
        cmp al, 10
        je disassembler_split_end
        cmp al, 0
        je disassembler_split_end
    disassembler_split_part2:
        ; add rsi, 2
        xor r14, r14
        xor rax, rax
        mov rax, [rsi]
        mov [x], al
        call convert_string_to_hex
        mul r15
        mov r14, rax
        add rsi, 1
        mov rax, [rsi]
        call convert_string_to_hex
        add r14, rax
        mov [dis_part2], r14b
        
        mov rax, [dis_part2]
        call disassembler_split_assign

        add rsi, 1
        mov rax, [rsi]
        ; cmp al, '\'
        ; je disassembler_split_part3
        cmp al, 10
        je disassembler_split_end
        cmp al, 0
        je disassembler_split_end
    disassembler_split_part3:
        ; add rsi, 2
        xor r14, r14
        xor rax, rax
        mov rax, [rsi]
        call convert_string_to_hex
        mul r15
        mov r14, rax
        add rsi, 1
        mov rax, [rsi]
        call convert_string_to_hex
        add r14, rax
        mov [dis_part3], r14b
        
        mov rax, [dis_part3]
        call disassembler_split_assign
        
        add rsi, 1
        mov rax, [rsi]
        ; cmp al, '\'
        ; je disassembler_split_part4
        cmp al, 10
        je disassembler_split_end
        cmp al, 0
        je disassembler_split_end
    disassembler_split_part4:
        ; add rsi, 2
        xor r14, r14
        xor rax, rax
        mov rax, [rsi]
        call convert_string_to_hex
        mul r15
        mov r14, rax
        add rsi, 1
        mov rax, [rsi]
        call convert_string_to_hex
        add r14, rax
        mov [dis_part4], r14b
        
        mov rax, [dis_part4]
        call disassembler_split_assign
        
        add rsi, 1
        mov rax, [rsi]
        ; cmp al, '\'
        ; je disassembler_split_part5
        cmp al, 10
        je disassembler_split_end
        cmp al, 0
        je disassembler_split_end
    disassembler_split_part5:
        ; add rsi, 2
        xor r14, r14
        xor rax, rax
        mov rax, [rsi]
        call convert_string_to_hex
        mul r15
        mov r14, rax
        add rsi, 1
        mov rax, [rsi]
        call convert_string_to_hex
        add r14, rax
        mov [dis_part5], r14b
        
        mov rax, [dis_part5]
        call disassembler_split_assign
        
        add rsi, 1
        mov rax, [rsi]
        ; cmp al, '\'
        ; je disassembler_split_part6
        cmp al, 10
        je disassembler_split_end
        cmp al, 0
        je disassembler_split_end
    disassembler_split_part6:
        ; add rsi, 2
        xor r14, r14
        xor rax, rax
        mov rax, [rsi]
        call convert_string_to_hex
        mul r15
        mov r14, rax
        add rsi, 1
        mov rax, [rsi]
        call convert_string_to_hex
        add r14, rax
        mov [dis_part6], r14b
        
        mov rax, [dis_part6]
        call disassembler_split_assign
        
        add rsi, 1
        mov rax, [rsi]
        ; cmp al, '\'
        ; je disassembler_split_part7
        cmp al, 10
        je disassembler_split_end
        cmp al, 0
        je disassembler_split_end
    disassembler_split_part7:
        ; add rsi, 2
        xor r14, r14
        xor rax, rax
        mov rax, [rsi]
        call convert_string_to_hex
        mul r15
        mov r14, rax
        add rsi, 1
        mov rax, [rsi]
        call convert_string_to_hex
        add r14, rax
        mov [dis_part7], r14b
        
        mov rax, [dis_part7]
        call disassembler_split_assign
        
        add rsi, 1
        mov rax, [rsi]
        cmp al, 10
        je disassembler_split_end
        cmp al, 0
        je disassembler_split_end
    disassembler_split_end:
        ret

disassembler_split_assign:
    xor rdx,rdx
    mov r9, rax
    mov r10, 16
    div r10

    cmp r9,  0x66 
    je disassembler_split_assign_prefix_code66
    
    cmp r9, 0x67
    je disassembler_split_assign_prefix_code67
    
    cmp rax, 4 
    je disassembler_split_assign_rex_code
    
    mov rax, [dis_opcode_busy]
    cmp rax, 0
    je disassembler_split_assign_opcode
    
    mov rax, [dis_mod_rm_busy]
    cmp rax, 0
    je disassembler_split_assign_mod_rm_code
    
    mov rax, [dis_sib_code_busy]
    cmp rax, 0
    je disassembler_split_assign_sib_code
    
    mov rax, [dis_displacement4_busy]
    cmp rax, 0
    je disassembler_split_assign_displacement4

    mov rax, [dis_displacement3_busy]
    cmp rax, 0
    je disassembler_split_assign_displacement3

    mov rax, [dis_displacement2_busy]
    cmp rax, 0
    je disassembler_split_assign_displacement2

    mov rax, [dis_displacement1_busy]
    cmp rax, 0
    je disassembler_split_assign_displacement1
    
    ret
    
    disassembler_split_assign_rex_code:
        mov [dis_rex_code], r9
        mov rbx, 1
        mov [dis_rex_code_busy], rbx
        ret
    disassembler_split_assign_prefix_code66:
        mov [dis_prefix_code66], r9
        mov rbx, 1
        mov [dis_prefix_code66_busy], rbx
        ret
    disassembler_split_assign_prefix_code67:
        mov [dis_prefix_code67], r9
        mov rbx, 1
        mov [dis_prefix_code67_busy], rbx
        ret
    disassembler_split_assign_opcode:
        mov [dis_opcode], r9
        mov rbx, 1
        mov [dis_opcode_busy], rbx
        ret
    disassembler_split_assign_mod_rm_code:
        mov [dis_mod_rm_code], r9
        mov rbx, 1
        mov [dis_opcode_busy], rbx
        ret
    disassembler_split_assign_sib_code:
        mov [dis_sib_code], r9
        mov rbx, 1
        mov [dis_sib_code], rbx
        ret
    disassembler_split_assign_displacement4:
        mov [dis_displacement4], r9
        mov rbx, 1
        mov [dis_displacement4_busy], rbx
        ret
    disassembler_split_assign_displacement3:
        mov [dis_displacement3], r9
        mov rbx, 1
        mov [dis_displacement3_busy], rbx
        ret
    disassembler_split_assign_displacement2:
        mov [dis_displacement2], r9
        mov rbx, 1
        mov [dis_displacement2_busy], rbx
        ret
    disassembler_split_assign_displacement1:
        mov [dis_displacement1], r9
        mov rbx, 1
        mov [dis_displacement1_busy], rbx
        ret
convert_string_to_hex:
    cmp al, 'a'
    jae convert_string_to_hex_alphabet
    sub rax, '0'
    ret
    convert_string_to_hex_alphabet:
        sub rax, 'a'
        mov rbx, 10
        add rax, rbx
        ret

disassembler_find_instruction_name:
    mov rsi, dis_opcode_table
    mov rbx, [dis_opcode]
    mov rax,rbx
    disassembler_find_instruction_name_loop:
        xor     rax,rax
        mov     al,[rsi]
        cmp     rbx,rax
        je      instruction_found
        inc     rsi
        cmp     rsi,dis_opcode_table_width
        jne     disassembler_find_instruction_name_loop
        ret
    instruction_found:
        mov     rdi,dis_instruction_name
        sub     rsi,dis_opcode_table
        mov     rax,rsi
        mov     rbx,[dis_opcode_table_width]
        xor     rdx,rdx
        div     rbx
        mov     rsi,dis_instruction_names_table
        lea     rsi,[rsi+rax*8]
        xor     rcx,rcx
    dis_instruction_loop:
        movsb
        inc     rcx
        cmp     byte[rsi],0
        jne     dis_instruction_loop
        mov     qword[dis_instruction_len],rcx
        mov     rdi,dis_instruction_name
        ret

disassembler_find_operands:
    mov     rax,[dis_mod_rm_code]
    mov     rbx,64
    xor     rdx,rdx
    div     rbx
    mov     [mod],rax
    cmp     rax,3 ; mod == 2'b11
    je      disassembler_reg_addressing_mode
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;tahte nezarat
    cmp     rax,0 ; mod = 2'b00
    je      disassembler_regular_indirect_addressing_mode
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;tahte nezarat
    ret

disassembler_regular_indirect_addressing_mode:
    mov     rax,[dis_mod_rm_code]
    mov     rbx,7 ;mask = 00000111
    and     rax,rbx
    mov     rsi,all_registers
    imul    rax,32
    call    is64reg
    call    is32reg
    call    is16reg
    mov     rcx,[dis_rex_code]
    and     rcx,1
    mov     [dis_is_new_reg_check],rcx
    call    isNewReg
    mov     rax,[rsi+rax]
    mov     [dis_regop],rax

    mov     rax,[dis_mod_rm_code]
    mov     rbx,56 ;mask = 00111000
    and     rax,rbx
    mov     rbx,8
    xor     rdx,rdx
    div     rbx
    mov     rsi,all_registers
    imul    rax,32
    call    is64reg
    call    is32reg
    call    is16reg
    mov     rcx,[dis_rex_code]
    and     rcx,4
    shr     rcx,2
    mov     [dis_is_new_reg_check],rcx
    call    isNewReg
    mov     rax,[rsi+rax]
    mov     [dis_rm],rax
    ret

disassembler_reg_addressing_mode:
    mov     rax,[dis_mod_rm_code]
    mov     rbx,56 ;mask = 00111000
    and     rax,rbx
    mov     rbx,8
    xor     rdx,rdx
    div     rbx
    mov     rsi,all_registers
    imul    rax,32
    call    is64reg
    call    is32reg
    call    is16reg
    mov     rcx,[dis_rex_code]
    and     rcx,4
    shr     rcx,2
    mov     [dis_is_new_reg_check],rcx
    call    isNewReg
    mov     rax,[rsi+rax]
    mov     [dis_regop],rax

    mov     rax,[dis_mod_rm_code]
    mov     rbx,7 ;mask = 00000111
    and     rax,rbx
    mov     rsi,all_registers
    imul    rax,32
    call    is64reg
    call    is32reg
    call    is16reg
    mov     rcx,[dis_rex_code]
    and     rcx,1
    mov     [dis_is_new_reg_check],rcx
    call    isNewReg
    mov     rax,[rsi+rax]
    mov     [dis_rm],rax
    ret

isNewReg:
    cmp     qword [dis_rex_code_busy],1
    jne     isnotNewReg
    cmp     byte [dis_is_new_reg_check],1
    jne     isnotNewReg
    mov     rbx,rax
    mov     rax,32
    imul    rax,7
    add     rax,rbx
    add     rax,8
isnotNewReg:
    ret

is64reg:
    cmp     qword [dis_rex_code_busy],1
    jne     isnot64reg
    mov     rbx,rax
    mov     rax,3
    imul    rax,8
    add     rax,rbx
isnot64reg:
    ret

is32reg:
    cmp     qword [dis_prefix_code67_busy],1
    je      itis32
    cmp     qword [dis_prefix_code66_busy],1
    je      isnot32reg
    mov     rcx,[dis_opcode]
    and     rcx,1
    cmp     rcx,1
    jne     isnot32reg
    cmp     qword [dis_rex_code_busy],1
    je     isnot32reg
itis32:
    mov     rbx,rax
    mov     rax,2
    imul    rax,8
    add     rax,rbx
isnot32reg:
    ret
    
is16reg:
    cmp     qword [dis_prefix_code66_busy],1
    jne     isnot16reg
    add     rax,8
isnot16reg:
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
assembler:
    ; split instruction name and operands
    call split_operands
    
    mov r13, operand_1
    mov r14, first_operand_type
    ; determine type of instruction: rr, rm, ri
    call determine_type_operand
    
    mov r13, operand_2
    mov r14, second_operand_type
    ; determine type of instruction: rr, rm, ri
    call determine_type_operand
    
    ; execute instruction type
    call execute_instruction           
    
    ; get opcode and fix opcode exception
    call get_opcode
    call fix_opcode
    call get_rex_code
    call get_prefix
    xor rax, rax
    mov byte [operand_1],0
    mov byte [operand_2],0
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_prefix:
    call get_prefix_operand
    call get_prefix_address
    ret
    get_prefix_address:
        mov rax, [prefix_address]
        cmp rax, 32
        je prefix_address_32_bit
        ret
        prefix_address_32_bit:
            mov rax, 0x67
            mov [prefix_1_code], rax
            mov rax, 1
            mov [prefix_1_code_permission], rax
            ret
            
    get_prefix_operand:
        mov rax, [prefix_operand]
        cmp rax, 16
        je prefix_operand_16_bit
        ret
        prefix_operand_16_bit:
            mov rax, 0x66
            mov [prefix_2_code], rax
            mov rax, 1
            mov [prefix_2_code_permission], rax
            ret
    
size_of_register:
    ; r13 denote to index of that register
    mov rax, r13
    mov r10, rax
    mov r9, 4
    div r9
    mul r9
    sub r10, rax
    mov rax, r10
    cmp rax, 0
    je size_of_register_64_bit
    cmp rax, 1
    je size_of_register_8_bit
    cmp rax, 2
    je size_of_register_16_bit
    cmp rax, 3
    je size_of_register_32_bit
    ret
    size_of_register_64_bit:
        mov rax, 64
        ret   
    size_of_register_32_bit:
        mov rax, 32
        ret
    size_of_register_16_bit:
        mov rax, 16
        ret
    size_of_register_8_bit:
        mov rax, 8
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
determine_type_operand:
    ; r13 points to first character of operand
    ; r14 points to i'th operand type
    mov rsi, r13
    mov rax, [rsi]
    cmp al, '['
    je memory_type
    cmp al, '0'
    je immediate_data_type
    cmp al, 32
    je no_type
    cmp al, 10
    je no_type
    cmp al, 0
    je no_type
    register_type:
        mov rax, 1
        mov [r14], rax
        ret
    memory_type:
        mov rax, 2
        mov [r14], rax
        ret
    immediate_data_type:
        mov rax, 3
        mov [r14], rax
        ret
    no_type:
        mov rax, 0
        mov [r14], rax
        ret
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
convert_displacement_to_hex:
    mov rsi, displacement
    add rsi, 8
    
    mov rdi, displacement_1
    mov r11, displacement_1_permission
    xor r10, r10
    call convert_displacement_to_hex_loop
    
    mov rdi, displacement_2
    mov r11, displacement_2_permission
    xor r10, r10
    call convert_displacement_to_hex_loop
    
    mov rdi, displacement_3
    mov r11, displacement_3_permission
    xor r10, r10
    call convert_displacement_to_hex_loop
    
    mov rdi, displacement_4
    mov r11, displacement_4_permission
    xor r10, r10
    call convert_displacement_to_hex_loop
    
    ret
    convert_displacement_to_hex_loop:
        mov rax, [rsi]
        mov [x], al
        cmp al, 5
        jbe convert_displacement_to_hex_loop_end

        call convert_string_to_hex
        mov r9, 16
        mul r9
        mov r10b, al
        add rsi, 4
        mov rax, [rsi]
        call convert_string_to_hex
        add r10b, al
        mov [rdi], r10
        mov rax, 1
        mov [r11], rax
        add rsi, 4
        ret
        convert_displacement_to_hex_loop_end:
            ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fix_rex_w_operand:
    mov r9, 4
    mov rax, r15
    cmp rax, 0
    je fix_rex_w_operand_zero
    mov r10, rax
    div r9
    mul r9
    sub r10, rax
    mov rax, r10
    cmp rax, 0
    je get_rex_code_w_64_bit
    ret
    fix_rex_w_operand_zero:
        ret
fix_rex_w:
    mov r15, [register1_index]
    call fix_rex_w_operand
    mov r15, [base_index]
    call fix_rex_w_operand
    mov r15, [sib_index_index]
    call fix_rex_w_operand
    ret
    get_rex_code_w_64_bit:
        mov rbx, 1
        mov [rex_w], rbx
        ret
    get_rex_code_w_not_64_bit:
        xor rbx, rbx
        mov [rex_w], rbx
        ret
fix_rex_r:
    mov r9, 4
    mov rax, [register1_index]
    div r9
    cmp ax, 8
    jae get_rex_code_r_new
    jb  get_rex_code_r_old
    ret
    get_rex_code_r_new:
        mov rbx, 1
        mov [rex_r], rbx
        ret
    get_rex_code_r_old:
        xor rbx, rbx
        mov [rex_r], rbx
        ret
fix_rex_x:
    mov r9, 4
    mov rax, [sib_index_index]
    cmp rax, 0
    je get_rex_code_x_old
    div r9
    cmp ax, 8
    jae get_rex_code_x_new
    jb get_rex_code_x_old
    get_rex_code_x_new:
        mov rbx, 1
        mov [rex_x], rbx
        ret
    get_rex_code_x_old:
        xor rbx, rbx
        mov [rex_x], rbx
        ret
fix_rex_b:
    mov r9, 4
    mov rax, [base_index]
    cmp rax, 0
    je get_rex_code_b_old
    div r9
    cmp ax, 8
    jae get_rex_code_b_new
    jb  get_rex_code_b_old
    ret
    get_rex_code_b_new:
        mov rbx, 1
        mov [rex_b], rbx
        ret
    get_rex_code_b_old:
        xor rbx, rbx
        mov [rex_b], rbx
        ret
get_rex_code:
    mov rax, 4
    mov [rex_o], rax
    call fix_rex_w
    call fix_rex_r
    call fix_rex_x
    call fix_rex_b
    
    mov rax, [rex_o]
    mov r9, 16
    mul r9
    mov r10, rax
    
    mov rax, [rex_w]
    mov r9, 8
    mul r9
    mov r11, rax
    
    mov rax, [rex_r]
    mov r9, 4
    mul r9
    mov r12, rax
    
    mov rax, [rex_x]
    mov r9, 2
    mul r9
    
    add rax, r10
    add rax, r11
    add rax, r12
    add rax, [rex_b]
    
    mov [rex_code], rax
    
    cmp rax, 0x40
    je rex_is_not_needed
    mov rax, 1
    mov [rex_code_permission], rax 
    ret
    
rex_is_not_needed:
    mov rax, 0
    mov [rex_code_permission], rax
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fix_opcode:
    mov rbx, [type_of_instruction]
    cmp rbx, 0
    je fix_opcode_end
    mov rbx, [register1_index]
    mov rcx, 4
    mov rax, rbx
    div rcx
    mul rcx
    sub rbx, rax
    mov rax, rbx
    xor rbx, rbx
    cmp rax, 1
    jne fix_opcode_not8_register
    ret
    fix_opcode_not8_register:
        mov rbx, 1
        mov rax, [opcode]
        add rax, rbx
        mov [opcode], rax
        ret
    fix_opcode_end:
        ret
;;;;;;;
get_opcode:
    xor rdx, rdx
    lea rdi, [instruction_names_table]
    mov rsi, [rdi + rdx]
    mov r10, rdi
    xor r9, r9            ; index of instruction name
    get_opcode_loop:
        lea rdi, [instruction_name]
        lea rsi, [r10 + rdx]
        push r9
        mov rcx, 3                ; length of instruction
        call compare_two_string
        mov rbx, r9
        pop r9
        cmp rbx, 1
        je get_opcode_end
        inc r9
        add rdx, 8
        jmp get_opcode_loop
    get_opcode_end:
        lea rsi, [opcode_table]
        mov [i_th_instruction], r9
        mov rax, r9
        mov rcx, [opcode_table_width]
        mul rcx
        add rax, [index_of_instruction_name]
        xor rcx, rcx
        mov cl, [rsi + rax]
        mov [opcode], rcx
        
        call get_opcode_push_pop
        call get_opcode_0f
        
        ; set permissions
        mov rax, 1
        mov [opcode_permission], rax
        
        ret
    get_opcode_push_pop:
        mov rax, [i_th_instruction]
        cmp al, 38
        je get_opcode_push
        ret
        get_opcode_push:
        
            ret
    get_opcode_0f:
        xor rax, rax
        mov rax, [i_th_instruction]
        cmp rax, 16
        je get_opcode_0f_assign
        cmp rax, 17
        je get_opcode_0f_assign
        cmp rax, 35
        je get_opcode_0f_assign
        ret
    get_opcode_0f_assign:
        mov rax, 0x0f
        mov [opcode_0f], rax
        mov rax, 1
        mov [opcode_0f_permission], rax
        ret
        
get_reg_code:
    xor rdx, rdx
    lea rdi, [instruction_names_table]
    mov rsi, [rdi + rdx]
    mov r10, rdi
    xor r9, r9            ; index of instruction name
    get_reg_code_loop:
        lea rdi, [instruction_name]
        lea rsi, [r10 + rdx]
        push r9
        mov rcx, 3                ; length of instruction
        call compare_two_string
        mov rbx, r9
        pop r9
        cmp rbx, 1
        je get_reg_code_end
        inc r9
        add rdx, 8
        jmp get_reg_code_loop
    get_reg_code_end:
        lea rsi, [opcode_table]
        mov [i_th_instruction], r9
        mov rax, r9
        mov r9, [opcode_table_width]
        mul r9
        mov rbx, 3  ; index of reg in opcode table 
        add rbx, rax
        mov al, [opcode_table + rbx]
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; specify which type of instruction should be executed like rr or rm or ri
execute_instruction:
    xor rax, rax
    xor rbx, rbx
    mov al, [first_operand_type]
    mov bl, [second_operand_type]
    mov rcx, 10
    mul rcx
    add rax, rbx
    mov [type_of_instruction], rax
    cmp rax, 11
    je register_register
    cmp rax, 12
    je register_memory
    cmp rax, 13
    je register_immediate
    cmp rax, 10
    je single_register
    cmp rax, 20
    je single_memory
    cmp rax, 0
    je single_instruction
    cmp rax, 21
    je memory_register
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
single_register:
    mov r13, operand_1
    call is_operand_register
    mov [base_code], al
    mov [base_index], r10
    
    xor rax, rax
    mov rax, 3
    mov [mod], rax
    mov r9, 64
    mul r9
    
    add rax, [base_code]
    mov [mod_rm_code], rax
    mov rax, 1
    mov [mod_rm_code_permission], rax
    
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
single_memory:
    ; for getting opcode
    mov rax, 5
    mov [index_of_instruction_name], rax

    xor r13, r13
    mov r13, operand_1
    call split_memory_operand
    call find_memory_part_base
    call find_memory_part_index
    call find_memory_part_displacement
    call memory_specify_type
    
    cmp rax, 111
    je memory_base_index_displacement
    cmp rax, 100
    je memory_base
    cmp rax, 010
    je memory_index
    cmp rax, 001
    je memory_displacement
    cmp rax, 110
    je memory_base_index
    cmp rax, 101
    je memory_base_displacement
    cmp rax, 011
    je memory_index_displacement
      
    ret
memory_base:
    mov rax, 0
    mov [mod], rax
    
    mov r13, base
    call is_operand_register
    mov [base_code], al
    mov [base_index], r10

    mov r9, [base_code]
    call get_reg_code
    mov r10, 8
    mul r10
    add rax, r9
    mov [mod_rm_code], rax
    
    mov r13, [base_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    
    ret
memory_index:
    mov rax, 0
    mov [mod], rax
    call get_reg_code
    mov r9, 8
    mul r9
    add rax, 4 ; add with sib code equal 100
    mov [mod_rm_code], rax
    
    mov r13, sib_index
    call is_operand_register
    mov [sib_index_code], al
    mov [sib_index_index], r10
    mov rax, [sib_index_code]
    mov r9, 8
    mul r9
    mov r10, rax
    call size_of_scale
    mov [sib_scale_size], al
    mov r9, 64
    mul r9
    add rax, r10
    add rax, 5
    mov [sib_code], rax
    
    mov r13, [sib_index_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    ret
memory_displacement:
    mov rax, 0
    mov [mod], rax
    
    call get_reg_code
    mov r9, 8
    mul r9
    add rax, 4
    mov [mod_rm_code], rax
    
    mov rax, 4
    mov [sib_index], rax
    mov r9, 8
    mul r9
    add rax, 5
    mov [sib_code], rax
    
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    call convert_displacement_to_hex
    
    
    ret

memory_base_index:
    mov rax, 0
    mov [mod], rax
    call get_reg_code
    mov r9, 8
    mul r9
    add rax, 4
    mov [mod_rm_code], rax
    
    call size_of_scale
    mov [sib_scale_size], al
    mov rax, [sib_scale_size]
    mov r9, 64
    mul r9
    mov r10, rax
    
    push r10
    mov r13, sib_index
    call is_operand_register
    mov [sib_index_code], al
    mov [sib_index_index], r10
    pop r10
    
    push r10
    mov r13, base
    call is_operand_register
    mov [base_code], al
    mov [base_index], r10
    pop r10
    
    mov rax, [sib_index_code]
    mov r9, 8
    mul r9
    add rax, r10
    add rax, [base_code]
    
    mov [sib_code], rax
    
    mov r13, [base_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    ret
     

memory_base_displacement:
    call size_of_displacement
    mov [mod], rax
    mov rax, [mod]
    mov r9, 64
    mul r9
    mov r10, rax
    
    call get_reg_code
    mov r9, 8
    mul r9
    mov r15, rax
    
    push r15
    push r10
    mov r13, base
    call is_operand_register
    mov [base_code], al
    mov [base_index], r10
    pop r10
    pop r15
    
    mov rax, [base_code]
    add rax, r15
    add rax, r10
    
    mov [mod_rm_code], rax
    
    mov r13, [base_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov rax, 0
    mov [sib_code_permission], rax
    
    call convert_displacement_to_hex
    
    ret

memory_index_displacement:
    mov rax, 0
    mov [mod], rax
    
    call get_reg_code
    mov r9, 8
    mul r9
  
    add rax, 4
    mov [mod_rm_code], rax
    
    call size_of_scale
    mov [sib_scale_size], al
    mov rax, [sib_scale_size]
    mov r10, rax
    
    push r10
    mov r13, sib_index
    call is_operand_register
    mov [sib_index_code], al
    mov [sib_index_index], r10
    pop r10
    
    mov rax, [sib_index_code]
    add rax, r10
    add rax, 5
    
    mov [sib_code], rax
    
    mov r13, [sib_index_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    call convert_displacement_to_hex
    
    
    ret
    
memory_base_index_displacement:
    call size_of_displacement
    mov [mod], rax
    call size_of_scale
    mov [sib_scale_size], ax
    mov rax, [mod]
    mov r9, 64
    mul r9
    mov rcx, rax
    call get_reg_code
    mov r9, 8
    mul r9
    add rax, rcx
    add rax, 4                 ; assign 100 to rm/code to show we use sib code
    mov [mod_rm_code], rax
    
    mov r13, base
    call is_operand_register
    mov [base_code], ax
    mov [base_index], r10
    
    mov r13, sib_index
    call is_operand_register
    mov [sib_index_code], ax
    mov [sib_index_index], r10
    
    mov rax, [sib_scale_size]
    mov r9, 64
    mul r9
    xor rcx, rcx
    mov rcx, rax
    mov rbx, [sib_index_code]
    mov rax, rbx
    mov r9, 8
    mul r9
    add rax, rcx
    mov rbx, [base_code]
    add rax, rbx
    
    mov [sib_code], rax
    
 
    
    mov r13, [base_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    call convert_displacement_to_hex
    
    
    ret    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
single_instruction:
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
memory_register:
    ; for getting opcode
    mov rax, 4
    mov [index_of_instruction_name], rax
    
    mov r13, operand_2
    call is_operand_register
    mov [first_operand_type], r9b
    mov [register1_code], al
    mov [register1_index], r10
    
    mov r13, [register1_index]
    call size_of_register
    mov [prefix_operand], rax

    xor r13, r13
    mov r13, operand_1
    call split_memory_operand
    call find_memory_part_base
    call find_memory_part_index
    call find_memory_part_displacement
    call memory_specify_type
    
    cmp rax, 111
    je memory_register_base_index_displacement
    cmp rax, 100
    je memory_register_base
    cmp rax, 010
    je memory_register_index
    cmp rax, 001
    je memory_register_displacement
    cmp rax, 110
    je memory_register_base_index
    cmp rax, 101
    je memory_register_base_displacement
    cmp rax, 011
    je memory_register_index_displacement
    ret
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
memory_register_base:
    mov rax, 0
    mov [mod], rax
    
    mov r13, base
    call is_operand_register
    mov [base_code], al
    mov [base_index], r10

    mov r9, [base_code]
    mov rax, [register1_code]
    mov r10, 8
    mul r10
    add rax, r9
    mov [mod_rm_code], rax
    
    mov r13, [base_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    
    call convert_displacement_to_hex
    
    
    ret
memory_register_index:
    mov rax, 0
    mov [mod], rax
    mov rax, [register1_code]
    mov r9, 8
    mul r9
    add rax, 4 ; add with sib code equal 100
    mov [mod_rm_code], rax
    
    mov r13, sib_index
    call is_operand_register
    mov [sib_index_code], al
    mov [sib_index_index], r10
    mov rax, [sib_index_code]
    mov r9, 8
    mul r9
    mov r10, rax
    call size_of_scale
    mov [sib_scale_size], al
    mov r9, 64
    mul r9
    add rax, r10
    add rax, 5
    mov [sib_code], rax
    
    mov r13, [sib_index_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    ret
memory_register_displacement:
    mov rax, 0
    mov [mod], rax
    
    mov rax, [register1_code]
    mov r9, 8
    mul r9
    add rax, 4
    mov [mod_rm_code], rax
    
    mov rax, 4
    mov [sib_index], rax
    mov r9, 8
    mul r9
    add rax, 5
    mov [sib_code], rax
    
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    call convert_displacement_to_hex
    
    
    ret

memory_register_base_index:
    mov rax, 0
    mov [mod], rax
    mov rax, [register1_code]
    mov r9, 8
    mul r9
    add rax, 4
    mov [mod_rm_code], rax
    
    call size_of_scale
    mov [sib_scale_size], al
    mov rax, [sib_scale_size]
    mov r9, 64
    mul r9
    mov r10, rax
    
    push r10
    mov r13, sib_index
    call is_operand_register
    mov [sib_index_code], al
    mov [sib_index_index], r10
    pop r10
    
    push r10
    mov r13, base
    call is_operand_register
    mov [base_code], al
    mov [base_index], r10
    pop r10
    
    mov rax, [sib_index_code]
    mov r9, 8
    mul r9
    add rax, r10
    add rax, [base_code]
    
    mov [sib_code], rax
    
    mov r13, [base_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    ret
     

memory_register_base_displacement:
    ;call size_of_displacement
    mov rax, 2
    mov [mod], rax
    mov rax, [mod]
    mov r9, 64
    mul r9
    mov r10, rax
    
    mov rax, [register1_code]
    mov r9, 8
    mul r9
    mov r15, rax
    
    push r15
    push r10
    mov r13, base
    call is_operand_register
    mov [base_code], al
    mov [base_index], r10
    pop r10
    pop r15
    
    mov rax, [base_code]
    add rax, r15
    add rax, r10
    
    mov [mod_rm_code], rax
    
    mov r13, [base_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov rax, 0
    mov [sib_code_permission], rax
    
    call convert_displacement_to_hex
    
    ret

memory_register_index_displacement:
    mov rax, 0
    mov [mod], rax
    
    mov rax, [register1_code]
    mov r9, 8
    mul r9
  
    add rax, 4
    mov [mod_rm_code], rax
    
    call size_of_scale
    mov [sib_scale_size], al
    mov rax, [sib_scale_size]
    mov r10, rax
    
    push r10
    mov r13, sib_index
    call is_operand_register
    mov [sib_index_code], al
    mov [sib_index_index], r10
    pop r10
    
    mov rax, [sib_index_code]
    add rax, r10
    add rax, 5
    
    mov [sib_code], rax
    
    mov r13, [sib_index_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    call convert_displacement_to_hex
    
    
    ret
    
memory_register_base_index_displacement:
    call size_of_displacement
    mov [mod], rax
    call size_of_scale
    mov [sib_scale_size], ax
    mov rax, [mod]
    mov r9, 64
    mul r9
    mov rcx, rax
    mov rbx, [register1_code]
    mov rax, rbx
    mov r9, 8
    mul r9
    add rax, rcx
    add rax, 4                 ; assign 100 to rm/code to show we use sib code
    mov [mod_rm_code], rax
    
    mov r13, base
    call is_operand_register
    mov [base_code], ax
    mov [base_index], r10
    
    mov r13, sib_index
    call is_operand_register
    mov [sib_index_code], ax
    mov [sib_index_index], r10
    
    mov rax, [sib_scale_size]
    mov r9, 64
    mul r9
    xor rcx, rcx
    mov rcx, rax
    mov rbx, [sib_index_code]
    mov rax, rbx
    mov r9, 8
    mul r9
    add rax, rcx
    mov rbx, [base_code]
    add rax, rbx
    
    mov [sib_code], rax
    
 
    
    mov r13, [base_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    call convert_displacement_to_hex
    
    
    ret    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
register_immediate_specify_opcode:
    mov rax, [register1_index]
    cmp rax, 1
    je register_immediate_al_rax
    cmp rax, 4
    je register_immediate_al_rax
    
    mov r13, [register1_index]
    call size_of_register
    cmp rax, 8
    jne register_immediate_16_bit
    
    ret
    
    register_immediate_16_bit:
        call size_of_displacement
        cmp rax, 1
        je register_immediate_r16_i8
        ret
        register_immediate_r16_i8:
            mov rbx, 7
            mov [index_of_instruction_name], rbx
            ret
    register_immediate_al_rax:
        mov rbx, 6
        mov [index_of_instruction_name], rbx
        ret
register_immediate:
    mov rax, 2
    mov [index_of_instruction_name], rax
    ; get code of register one
    mov r13, operand_1
    call is_operand_register
    mov [register1_code], al
    mov [register1_index], r10
     
    call register_immediate_split_data
    call register_immediate_instruction
    
    call register_immediate_specify_opcode 
    
    call convert_displacement_to_hex
    
    mov rax, 3 ;mod
    mov r9, 64
    mul r9
    add rax, [register_immediate_reg]
    add rax, [register1_code]
    mov [mod_rm_code], al
    
    mov r13, [register1_index]
    call size_of_register
    mov [prefix_operand], rax
    
    ;set permissions
    mov rax, 1
    mov [mod_rm_code_permission], rax
    
    mov rax, 1
    mov [displacement_permission], rax
    ret
register_immediate_instruction:
    xor rdx, rdx
    lea rdi, [instruction_names_table]
    mov rsi, [rdi + rdx]
    mov r10, rdi
    xor r9, r9            ; index of instruction name
    register_immediate_instruction_loop1:
        lea rdi, [instruction_name]
        lea rsi, [r10 + rdx]
        
        push r9
        mov rcx, 3                ; length of instruction
        call compare_two_string
        mov rbx, r9
        pop r9
        
        cmp rbx, 1
        je register_immediate_instruction_end
        
        inc r9
        add rdx, 8
        jmp register_immediate_instruction_loop1
    register_immediate_instruction_end:
        lea rsi, [opcode_table]
        mov rax, r9
        mov rcx, 4
        mul rcx
        xor rcx, rcx
        mov rcx, [rsi + rax]
        mov [register_immediate_reg], rcx
        ret   
register_immediate_split_data:
    mov rsi, operand_2
    mov rdi, displacement
    xor r9, r9
    register_immediate_split_data_loop:
        mov rax, [rsi]
        cmp al, 0
        je register_immediate_split_data_end
        mov [rdi], al
        add rdi, 4
        add rsi, 4
        inc r9
        jmp register_immediate_split_data_loop
    register_immediate_split_data_end:
        mov [displacement_len], r9b
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
register_memory:
    mov rax, 1
    mov [index_of_instruction_name], rax
    ; get code of register one
    mov r13, operand_1
    call is_operand_register
    mov [first_operand_type], r9b
    mov [register1_code], al
    mov [register1_index], r10
    
    mov r13, [register1_index]
    call size_of_register
    mov [prefix_operand], rax
    
    ; here we should split memory operand to get scale disp
    xor r13, r13
    mov r13, operand_2
    call split_memory_operand
    call find_memory_part_base
    call find_memory_part_index
    call find_memory_part_displacement
    call memory_specify_type
    cmp rax, 111
    je register_memory_base_index_displacement
    cmp rax, 100
    je register_memory_base
    cmp rax, 010
    je register_memory_index
    cmp rax, 001
    je register_memory_displacement
    cmp rax, 110
    je register_memory_base_index
    cmp rax, 101
    je register_memory_base_displacement
    cmp rax, 011
    je register_memory_index_displacement
    ret

split_memory_operand:
    ; r13 denote to operand_1 or operand_2
    mov rsi, r13
    xor r9, r9
    xor r10, r10
    xor r11, r11
    xor r13, r13
    xor r14, r14
    xor rdi, rdi
    split_memory_operand_loop1:
        add rsi, 4
        mov rax, [rsi]
        cmp al, '+'
        je split_memory_operand_loop2
        cmp al, ']'
        je split_memory_operand_end
        cmp al, 0
        je split_memory_operand_end
        mov [memory_part1 + rdi], al
        inc r9
        add rdi, 4
        jmp split_memory_operand_loop1
    split_memory_operand_loop2:
        add rsi, 4
        mov rax, [rsi]
        cmp al, '+'
        je split_memory_operand_loop3
        cmp al, 0
        je split_memory_operand_end
        cmp al, ']'
        je split_memory_operand_end
        mov [memory_part2 + r13], al
        inc r10
        add r13, 4
        jmp split_memory_operand_loop2
    split_memory_operand_loop3:
        add rsi, 4
        mov rax, [rsi]
        cmp al, ']'
        je split_memory_operand_end
        cmp al, 0
        je split_memory_operand_end
        mov [memory_part3 + r14], al
        inc r11
        add r14, 4
        jmp split_memory_operand_loop3
    split_memory_operand_end:
        xor rbx, rbx
        xor r12, r12
        ;if_it_is_not_zero_increment r9
        add r12, rax
        ;if_it_is_not_zero_increment r10
        add r12, rax
        ;if_it_is_not_zero_increment r11
        add r12, rax
        mov [memory_count_parts], r12
        ret
find_memory_part_base:
    mov rsi, memory_part1
    mov rdi, base
    mov rax, [rsi]
    mov rbx, [rsi + 4]
    mov [x], bl
    xor r10, r10
    cmp al, '0'
    je not_found_memory_part_base
    cmp bl, '*'
    je not_found_memory_part_base
    find_memory_part_base_loop1:
        mov rax, [rsi]
        cmp al, 0
        je find_memory_part_base_end
        mov [rdi], al
        add rsi, 4
        add rdi, 4
        inc r10
        jmp find_memory_part_base_loop1
    not_found_memory_part_base:
        xor rax, rax
        mov [base_flag], rax
        ret
    find_memory_part_base_end:
        xor rax, rax
        mov rax, 1
        mov [base_flag], rax
        mov [base_len], r10
        ret
        
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
find_memory_part_index:                       ; here we look for index part and split it to scale and index
    mov rsi, memory_part1
    mov r9, rsi
    xor r10, r10                              ; for counting length of index
    find_memory_part_index_loop1:
        mov rax, [rsi]
        mov [x], al
        cmp al, '*'
        je find_memory_part_index_end
        cmp al, 0
        je find_memory_part_index_part2
        add rsi, 4
        jmp find_memory_part_index_loop1
    find_memory_part_index_part2:
        mov rsi, memory_part2
        mov r9, rsi
        find_memory_part_index_loop2:
            mov rax, [rsi]
            cmp al, '*'
            je find_memory_part_index_end
            cmp al, 0
            je find_memory_part_index_part3
            add rsi, 4
            jmp find_memory_part_index_loop2
    find_memory_part_index_part3:
        mov rsi, memory_part3
        mov r9, rsi
        find_memory_part_index_loop3:
            mov rax, [rsi]
            cmp al, '*'
            je find_memory_part_index_end
            cmp al, 0
            je not_found_memory_part_index
            add rsi, 4
            jmp find_memory_part_index_loop3
    find_memory_part_index_end:
        mov rsi, r9
        mov rdi, sib_index
        find_memory_part_index_end_loop1:
            mov rax, [rsi]
            cmp al, '*'
            je find_memory_part_index_end_loop2
            mov [scale], al
            add rsi, 4
            mov rdi, sib_index
            jmp find_memory_part_index_end_loop1
        find_memory_part_index_end_loop2:
            add rsi, 4
            mov rax, [rsi]
            cmp al, 0
            je find_memory_part_index_end_finished
            mov [rdi], al
            mov [x], al
            add rdi, 4
            inc r10
            jmp find_memory_part_index_end_loop2
    find_memory_part_index_end_finished:
        xor rax, rax
        mov rax, 1
        mov [sib_index_flag], rax
        mov [sib_index_len], r10
        ret
    not_found_memory_part_index:
        xor rax, rax
        mov [sib_index_flag], rax
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
find_memory_part_displacement:          ; looking for part that displacement exist.
    mov rsi, memory_part1
    xor r9, r9
    xor r10, r10
    find_memory_part_displacement_part1:
        mov rax, [rsi]
        cmp al, '0'
        je find_memory_part_displacement_end
    find_memory_part_displacement_part2:
        mov rsi, memory_part2
        mov rax, [rsi]
        cmp al, '0'
        je find_memory_part_displacement_end
    find_memory_part_displacement_part3:
        mov rsi, memory_part3
        mov rax, [rsi]
        cmp al, '0'
        je find_memory_part_displacement_end
        jne not_found_memory_part_displacement
    find_memory_part_displacement_end:
        mov rax, [rsi]
        cmp al, 0
        je find_memory_part_displacement_end_finished
        mov [displacement + r9], al
        add rsi, 4
        add r9, 4
        inc r10
        jmp find_memory_part_displacement_end
    find_memory_part_displacement_end_finished:
        xor rax, rax
        mov rax, 1
        mov [displacement_flag], rax
        mov [displacement_len], r10
        ret
    not_found_memory_part_displacement:
        xor rax, rax
        mov [displacement_flag], rax
        ret


memory_specify_type:   ; 111 : base_index_disp, 110: base_index, 101:base_disp, ....
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx
    mov rbx, [base_flag]
    mov rcx, [sib_index_flag]
    mov r10, [displacement_flag]
    mov rax, rbx
    xor r9, r9
    mov r9, 100
    mul r9
    mov rbx, rax
    mov rax, rcx
    mov r9, 10
    mul r9
    add rax, rbx
    add rax, r10
    ret
    
size_of_displacement:
    xor rax, rax
    mov rax, [displacement_len]
    cmp rax, 4
    jbe size_of_displacement_8_bit
    ja size_of_displacement_32_bit
    ret
    size_of_displacement_8_bit:
        xor rax, rax
        mov rax, 1
        ret
    size_of_displacement_32_bit:
        xor rax, rax
        mov rax, 2
        ret
size_of_scale:
    mov rsi, scale
    mov rax, [rsi]
    cmp al, '1'
    je scale_1
    cmp al, '2'
    je scale_2
    cmp al, '4'
    je scale_4
    cmp al, '8'
    je scale_8
    scale_1:
        xor rax, rax
        mov rax, 0
        ret
    scale_2:
        xor rax, rax
        mov rax, 1
        ret
    scale_4:
        xor rax, rax
        mov rax, 2
        ret
    scale_8:
        mov rax, rax
        mov rax, 3
        ret
register_memory_base:
    mov rax, 0
    mov [mod], rax
    
    mov r13, base
    call is_operand_register
    mov [base_code], al
    mov [base_index], r10

    mov r9, [base_code]
    mov rax, [register1_code]
    mov r10, 8
    mul r10
    add rax, r9
    mov [mod_rm_code], rax
    
    mov r13, [base_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    
    ret
register_memory_index:
    mov rax, 0
    mov [mod], rax
    mov rax, [register1_code]
    mov r9, 8
    mul r9
    add rax, 4 ; add with sib code equal 100
    mov [mod_rm_code], rax
    
    mov r13, sib_index
    call is_operand_register
    mov [sib_index_code], al
    mov [sib_index_index], r10
    mov rax, [sib_index_code]
    mov r9, 8
    mul r9
    mov r10, rax
    call size_of_scale
    mov [sib_scale_size], al
    mov r9, 64
    mul r9
    add rax, r10
    add rax, 5
    mov [sib_code], rax
    
    mov r13, [sib_index_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    ret
register_memory_displacement:
    mov rax, 0
    mov [mod], rax
    
    mov rax, [register1_code]
    mov r9, 8
    mul r9
    add rax, 4
    mov [mod_rm_code], rax
    
    mov rax, 4
    mov [sib_index], rax
    mov r9, 8
    mul r9
    add rax, 5
    mov [sib_code], rax
    
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    call convert_displacement_to_hex
    
    ret

register_memory_base_index:
    mov rax, 0
    mov [mod], rax
    mov rax, [register1_code]
    mov r9, 8
    mul r9
    add rax, 4
    mov [mod_rm_code], rax
    
    call size_of_scale
    mov [sib_scale_size], al
    mov rax, [sib_scale_size]
    mov r9, 64
    mul r9
    mov r10, rax
    
    push r10
    mov r13, sib_index
    call is_operand_register
    mov [sib_index_code], al
    mov [sib_index_index], r10
    pop r10
    
    push r10
    mov r13, base
    call is_operand_register
    mov [base_code], al
    mov [base_index], r10
    pop r10
    
    mov rax, [sib_index_code]
    mov r9, 8
    mul r9
    add rax, r10
    add rax, [base_code]
    
    mov [sib_code], rax
    
    mov r13, [base_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    ret
     

register_memory_base_displacement:
    call size_of_displacement
    mov [mod], rax
    mov rax, [mod]
    mov r9, 64
    mul r9
    mov r10, rax
    
    mov rax, [register1_code]
    mov r9, 8
    mul r9
    mov r15, rax
    
    push r15
    push r10
    mov r13, base
    call is_operand_register
    mov [base_code], al
    mov [base_index], r10
    pop r10
    pop r15
    
    mov rax, [base_code]
    add rax, r15
    add rax, r10
    
    mov [mod_rm_code], rax
    
    mov r13, [base_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov rax, 0
    mov [sib_code_permission], rax
    
    call convert_displacement_to_hex
    
    ret

register_memory_index_displacement:
    mov rax, 0
    mov [mod], rax
    
    mov rax, [register1_code]
    mov r9, 8
    mul r9
  
    add rax, 4
    mov [mod_rm_code], rax
    
    call size_of_scale
    mov [sib_scale_size], al
    mov rax, [sib_scale_size]
    mov r10, rax
    
    push r10
    mov r13, sib_index
    call is_operand_register
    mov [sib_index_code], al
    mov [sib_index_index], r10
    pop r10
    
    mov rax, [sib_index_code]
    add rax, r10
    add rax, 5
    
    mov [sib_code], rax
    
    mov r13, [sib_index_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    call convert_displacement_to_hex
    
    ret
    
register_memory_base_index_displacement:
    call size_of_displacement
    mov [mod], rax
    call size_of_scale
    mov [sib_scale_size], ax
    mov rax, [mod]
    mov r9, 64
    mul r9
    mov rcx, rax
    mov rbx, [register1_code]
    mov rax, rbx
    mov r9, 8
    mul r9
    add rax, rcx
    add rax, 4                 ; assign 100 to rm/code to show we use sib code
    mov [mod_rm_code], rax
    
    mov r13, base
    call is_operand_register
    mov [base_code], ax
    mov [base_index], r10
    
    mov r13, sib_index
    call is_operand_register
    mov [sib_index_code], ax
    mov [sib_index_index], r10
    
    mov rax, [sib_scale_size]
    mov r9, 64
    mul r9
    xor rcx, rcx
    mov rcx, rax
    mov rbx, [sib_index_code]
    mov rax, rbx
    mov r9, 8
    mul r9
    add rax, rcx
    mov rbx, [base_code]
    add rax, rbx
    
    mov [sib_code], rax
    
 
    
    mov r13, [base_index]
    call size_of_register
    mov [prefix_address], rax
    
    ; set permission
    mov rax, 1
    mov [mod_rm_code_permission], rax
    mov [sib_code_permission], rax
    
    call convert_displacement_to_hex
    
    ret    
    
;;;;;;;;;;;;;;;;;;;;;;;one;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
register_register:
    mov rax, 0
    mov [index_of_instruction_name], rax
    
    mov r13, operand_1                 ; first index of operand1
    call is_operand_register          
    mov [first_operand_type], r9b
    mov [register1_code], al           ; assign register code
    mov [register1_index], r10
    
    mov r13, operand_2                 ; first index of operand2
    call is_operand_register
    mov [second_operand_type], r9b
    mov [register2_code], al           ; assign register code
    mov [register2_index], r10
    
    mov al, 0x3                     ; mod in this type is 11
    mov [mod], al
    xor r9, r9
    mov r9b, [mod]
    mov rcx, 64                     ; mod is multiplied by 64
    mov rax, r9
    mul rcx
    mov r9, rax               
    xor r10, r10
    xor r11, r11
    mov r10b, [register1_code]      
    mov r11b, [register2_code]
    mov rcx, 8
    mov rax, r11
    mul rcx
    mov r11, rax
    add r9, r11
    add r9, r10
    mov [mod_rm_code], r9
    
    mov r13, [register1_index]
    call size_of_register
    mov [prefix_operand], rax
     
    ; set permissions
    mov rax, 1
    mov [mod_rm_code_permission], rax

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; assign rsi to first string
    ; assign rdi to second string
    ; assign length of second string in rcx
    ; r9 = isequal ? 1 : 0
compare_two_string:
    compare_two_string_loop:
        cmp rcx, 0
        je two_string_equal
        mov rax, [rsi]
        mov rbx, [rdi]
        mov [y], al
        mov [z], bl
        cmp al, bl
        jne two_string_not_equal
        add rsi, 1
        add rdi, 4
        dec rcx
        jmp compare_two_string_loop
    two_string_equal:
        mov r9, 1
        ret
    two_string_not_equal:
        mov r9, 0
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; compute operand length 
compute_length_of_operand:
    mov rdi, r13
    xor rbx, rbx
    compute_length_of_operand_loop:
        xor rax, rax
        mov rax, [rdi]
        cmp al, 0
        je compute_length_of_operand_end 
        inc rbx
        add rdi, 1
        jmp compute_length_of_operand_loop
    compute_length_of_operand_end:
        mov [operand_len], rbx
        ret      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_operand_register:
    ;r13 denotes address of first character of operand so you should point to it
    xor rdx, rdx
    xor rsi, rsi
    lea rdi, [all_registers] ; start of array of strings
    mov rsi, [rdi + rdx]     ; start of each block of array
    xor r10, r10             ; code of register
    mov r15, rdi
    mov r14, 56
    is_operand_register_loop:
        cmp r14, 0
        je is_operand_register_not_equal
        dec r14
        lea rsi, [r15 + rdx]        ; each register from register table
        mov rdi, r13                ; operand
        push r13
        mov r13, rsi
        push rbx
        push rdi
        push rsi
        call compute_length_of_operand
        pop rsi
        pop rdi
        pop rbx
        pop r13
        ; debug it should be deleted
        xor rcx, rcx
        mov rcx, [rsi]
        mov [x], rcx
        mov rcx, [rsi+1]
        mov [x+1], rcx
        mov rcx, [rsi+2]
        mov [x+2], rcx
        ;;;;;;;;;;;;;;;;;;;;;;
        xor rcx, rcx
        mov rcx, [operand_len]      ; length of second register
        inc r10                     ; index of same register
        push rax
        push rbx
        call compare_two_string
        pop rax
        pop rbx
        cmp r9, 1
        je is_operand_register_equal
        add rdx, 8
        jmp is_operand_register_loop
    is_operand_register_equal:
        mov r9, 1
        mov rax, r10
        dec rax
        xor rdx, rdx
        mov rbx, 4               ; the number of register belongs to one code is 4
        div rbx
        cmp rax, 8
        jae is_operand_register_equal_greater_than_7
        ret 
        is_operand_register_equal_greater_than_7:
            mov rbx, 8
            sub rax, rbx
            ret
    is_operand_register_not_equal:
        xor rax, rax
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
split_operands:
    mov rsi, buffer
    mov rdi, instruction_name
    xor r9, r9 ;count length of each part
    split_operands_loop1:
        xor rax, rax
        mov rax, [rsi] ; assign character of buffer to rax
        cmp al, ' '    ; compare with space to split instruction name
        je operand1
        cmp al, 10
        je split_operands_end
        cmp al, 0
        je split_operands_end
        inc r9         ; length of first operand
        mov [rdi], al
        mov [x], rax   ; for testing each character
        add rsi, 1
        add rdi, 4
        jmp split_operands_loop1
    operand1:
        xor rax, rax
        xor r9, r9
        add rsi, 1
        xor rdi, rdi
        mov rdi, operand_1
        split_operands_loop2:
            xor rax, rax
            mov rax, [rsi]
            cmp al, ','
            je operand2
            cmp al, 10
            je split_operands_end
            cmp al, 0
            je split_operands_end
            inc r9         ; length of second operand
            mov [rdi], al  ; assign buffer character to operand2
            mov [x], rax   ; just for testing
            add rsi, 1
            add rdi, 4
            jmp split_operands_loop2
    operand2:
        xor rax, rax
        xor r9, r9
        add rsi, 1
        xor rdi, rdi
        mov rdi, operand_2
        split_operands_loop3:
            xor rax, rax
            mov rax, [rsi]
            cmp al, 10
            je split_operands_end
            cmp al, 0
            je split_operands_end
            inc r9               ; length of third operand
            mov [rdi], rax
            mov [x], rax         ; just for testing
            add rsi, 1
            add rdi, 4
            jmp split_operands_loop3
    split_operands_end:
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;  printString:
;      push rax
;      push rsi
;      push rdx
;      push rdi
   
;      mov rsi, rdi
;      call GetStrlen
;      mov rax, sys_write
;      mov rdi, stdout
;      syscall
    
;      pop rdi
;      pop rdx
;      pop rsi
;      pop rax
;      ret
;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  GetStrlen:
;      push rbx
;      push rcx
;      push rax
    
;      xor rcx, rcx
;      not rcx
;      xor rax, rax
;      cld
;      repne scasb
;      not rcx
;      lea rdx, [rcx - 1]
    
;      pop rax
;      pop rcx
;      pop rbx
;      ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
openFile:
    mov rax, sys_open
    mov rsi, O_RDWR
    xor rdx, rdx
    xor rbx, rbx
    xor rcx, rcx
    syscall
    cmp rax, -1
    jle openerror
    mov rdi, suces_open
    push rax
    call printString
    pop rax
    ret
openerror:
    mov rdi, error_open
    call printString
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
createFile:
    mov rax, sys_create
    mov rsi, sys_IRUSR | sys_IWUSR
    syscall
    cmp rax, -1 ; file descriptor
    jle createerror
    mov rdi, suces_create
    push rax
    call printString
    pop rax
    ret
createerror:
    mov rdi, error_create
    call printString
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
seekFile:
    mov rax, sys_lseek
    syscall
    cmp rax, -1
    jle seekerror
    mov rdi, suces_seek
    call printString
    ret
seekerror:
    mov rdi, error_seek
    call printString
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
readFile:
    mov rax, sys_read
    syscall 
    cmp rax, -1 ; number of read
    jle readerror
    mov byte [rsi + rax], 0 ; add a zero
    mov rdi, suces_read
    call printString
    ret
readerror:
    mov rdi, error_read
    call printString
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
writeFile:
    mov rax, sys_write
    syscall
    cmp rax, -1 ; number
    jle writeerror
    mov rdi, suces_write
    call printString
    ret
writeerror:
    mov rdi, error_write
    call printString
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
closeFile:
    mov rax, sys_close
    syscall 
    cmp rax, -1   ; 0 successful
    jle closeerror
    mov rdi, suces_close
    call printString
    ret
closeerror:
    mov rdi, error_close
    call printString
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
deleteFile:
    mov rax, sys_unlink
    syscall 
    cmp rax, -1 ; 0 sucessful
    jle deleterror
    mov rdi, suces_delete
    call printString
    ret
deleterror:
    mov rdi, error_delete
    call printString
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;