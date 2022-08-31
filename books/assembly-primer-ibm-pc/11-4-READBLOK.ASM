;READBLOK--Read File, using Random Block Read
;           Display file on screen

doscall equ     21h     ;DOS interrupt number
openf   equ     0fh     ;Open File function
get_fs  equ     23h     ;get file size funct
display equ     2h      ;Display Character fun
print_m equ     9h      ;print message funct
block_r equ     27h     ;Random Block Read fun
set_ran equ     24h     ;set random rec field

r_size  equ     80h     ;record size
fcb     equ     5ch     ;file control block
eof     equ     1ah     ;end-of-file character

;*********************************************
datarea segment         ;program segment prefix

        org     6ah
rs_field    dw  ?       ;rec size field in FCB

        org     7dh
r1      dw      ?       ;random rec size (low)
r2      dw      ?       ;random rec size (hi)

        org     80h     ;start of DTA
dta     db  80h dup (?) ;data transfer area

mess1   db  'No such filename.$'
mess2   db  'Bad read.$'

datarea ends
;*********************************************

pro_nam segment         ;define code segment

;---------------------------------------------
main    proc    far     ;main part of program

        assume  cs:pro_nam,ds:datarea

start:          ;starting execution address

;set up stack for return
        push    ds          ;save old data segment
        sub     ax,ax       ;put zero in AX
        push    ax          ;save it on stack

;SET RECORD SIZE IN FCB
        mov     rs_field,r_size

;GET FILE SIZE
        mov     dx,fcb      ;FCB into DX
        mov     ah,get_fs   ;get file size funct
        int     doscall     ;call DOS
        inc     al          ;is AL=0? (was it FF?)
        jz      nofile      ;yes, so no file found
        mov     cx,r1       ;put file size into CX

;OPEN THE FILE
        mov     dx,fcb      ;put FCB addr in DX
        mov     ah,openf    ;Open File function
        int     doscall     ;call DOS

;ZERO OUT RANDOM RECORD FIELD
        mov     r1,0        ;low byte
        mov     r2,0        ;high byte

;READ BLOCK
;(number of records still in CX)
        mov     dx,fcb      ;put FCB address in DX
        mov     ah,block_r  ;block read function
        int     doscall     ;call DOS
        or      al,al       ;check if read o.k.
        jnz     bad_read    ;if AL not 0, bad read

;PRINT OUT CONTENTS OF BUFFER
        mov     ax,r_size   ;bytes/record in AX
        mul     cx          ;# of records in CX
        mov     cx,ax       ;# of bytes now in CX
        mov     bx,0        ;set pointer to 0
do_print:
        mov     dl,[dta + bx] ;get character
        cmp     dl,eof      ;end-of-file (1A) ?
        je      exit        ;yes
        mov     ah,display  ;display function
        int     doscall     ;call DOS
        inc     bx          ;bump pointer
        loop    do_print    ;do all characters
exit:   ret                 ;return to DOS

;PRINT OUT MESSAGES
nofile:
        mov     dx,offset mess1 ;get message
        jmp     print_mess
bad_read:
        mov     dx,offset mess2 ;get message
        jmp     print_mess
print_mess:
        mov     ax,datarea  ;put data segment
        mov     ds,ax       ;in DS register
        mov     ah,print_m  ;print message funct
        int     doscall     ;call DOS
        ret                 ;return to DOS

main    endp    ;end of main part of program
;---------------------------------------------
pro_nam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly
