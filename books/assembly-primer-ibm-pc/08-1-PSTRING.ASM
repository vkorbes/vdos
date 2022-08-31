;PSTRING--Program to print a string
;  Demonstrates EXE files

display equ     2h  ;display output function
doscall equ     21h ;DOS interrupt number

count   equ     49d ;# of characters in string

;*********************************************

datarea segment     ;define data segment

;string to be printed

string  db  'She is the most fair, though she be'
        db  'marble-hearted.',0dh,0ah

datarea ends

;*********************************************

prognam segment     ;define code segment

;---------------------------------------------
main    proc    far ;main part of program

        assume  cs:program,ds:datarea

start:          ;starting execution address

;set up stack for return
        push    ds      ;save old data segment
        sub     ax,ax   ;put zero in AX
        push    ax      ;save it on stack

;set DS register to current data segment
        mov     ax,datarea  ;datarea segment addr
        mov     ds,ax       ;  into DS register

;PRINT CHARACTERS FROM STRING ON SCREEN

        mov     cx,count    ;put # of chars in CX
        mov     bx,offset string ;add of string

next_char:
        mov     dl,[bx]     ;put one char in DL
        mov     ah,display  ;Display Char function
        int     doscall     ;call DOS
        inc     cx          ;advance pointer
        loop    next_char   ;repeat until done

        ret                 ;return to DOS

main    endp    ;end of main part of program
;---------------------------------------------
prognam ends    ;end of code segment
;*********************************************

        end     start   ;end assembly