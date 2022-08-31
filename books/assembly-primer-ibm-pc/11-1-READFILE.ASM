;READFILE--Reads sequential records of file

doscall equ     21h     ;DOS interrupt number
openf   equ     0fh     ;Open File function
readseq equ     14h     ;Read Sequential rec
display equ     2h      ;Display Charac funct
fcb     equ     5ch     ;file control block
eof     equ     1ah     ;end-of-file character

;*********************************************

datarea segment         ;define data segment

        org 7ch
recno   db  ?           ;record number

        org 80h
dta     db  80h dup (?) ;data transfer area

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

;OPEN DISK FILE, SET RECORD NUMBER TO 0
        mov     dx,fcb      ;set DX to FCB
        mov     ah,openf    ;Open File function
        int     doscall     ;call DOS
        mov     recno,0     ;put 0 in 7C

;READ RECORD FROM FILE, sequential mode
read_sec:
        mov     dx,fcb      ;set DX to FCB
        mov     ah,readseq  ;Read Rec function
        int     doscall     ;call DOS

;PRINT RECORD FROM DISK TRANSFER AREA (DTA)
        mov     cx,80h      ;number of chars in CX
        mov     bx,0        ;initialize BX pointer
printit:
        mov     dl,[dta + bx]   ;get character
        cmp     dl,eof          ;end-of-file (1A) ?
        je      exit            ;yes, so file finished

        mov     ah,display      ;Display function
        int     doscall         ;call DOS
        inc     bx              ;bump the pointer
        loop    printit         ;do 80h times
        jmp     read_rec        ;go get another record

exit:   ret                     ;return to DOS

main    endp    ;end of main part of program
;---------------------------------------------
pro_nam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly