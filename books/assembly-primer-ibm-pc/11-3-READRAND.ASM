;READRAND--Reads random record in file
;            record number is typed in by user

doscall equ     21h     ;DOS interrupt number
openf   equ     0fh     ;Open File function
readran equ     21h     ;Read Random Record
display equ     2h      ;Display Character fun
key_in  equ     1h      ;Keyboard Input funct
fcb     equ     5ch     ;file control block
eof     equ     1ah     ;end-of-file character

;*********************************************

datarea segment         ;program segment prefix

        org 7dh         ;random rec numbers in FCB
randlow dw  ?           ;random record number (lo)
randhi  dw  ?           ;random record number (hi)

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


;OPEN DISK FILE
        mov     dx,fcb      ;set DX to FCB
        mov     ah,openf    ;Open File function
        int     doscall     ;call DOS

;GET RECORD NUMBER FROM KBD, PUT IN FCB
        mov     ah,key_in   ;Keyboard Input funct
        int     doscall     ;call DOS
        sub     al,30h      ;convert to binary #
        cbw                 ;convert byte to word
        mov     randlow,ax  ;put in FCB random low
        mov     randhi,0    ;put 0 in random high

;READ RECORD FROM FILE, random mode
        mov     dx,fcb      ;set DX to FCB
        mov     ah,readran  ;Read Rec function
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

exit:   ret                     ;return to DOS

main    endp    ;end of main part of program
;---------------------------------------------
pro_nam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly
