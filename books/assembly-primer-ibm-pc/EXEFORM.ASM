;PROGRAM TITLE GOES HERE--
;  Followed by descriptive phrases

;EQU STATEMENTS GO HERE

;*********************************************

st_seg  segment stack   ;define stack segment
        db      20 dup  ('stack   ')

st_seg ends

;*********************************************

datarea segment         ;define data segment

;DATA GOES HERE

datarea ends
;*********************************************

prognam segment         ;define code segment

;---------------------------------------------

main    proc    far     ;main part of program

        assume  cs:prognam,ds:datarea

start:          ;starting execution address

;set up stack for return
        push    ds          ;save old data segment
        sub     ax,ax       ;put zero in AX
        push    ax          ;save it on stack

;set DS register to current data segment
        mov     ax,datarea  ;datarea segment addr
        mov     ds,ax       ;  into DS register

;MAIN PART OF PROGRAM GOES HERE

        ret                 ;return to DOS

main    endp    ;end of main part of program
;---------------------------------------------
subr1   proc    near        ;define subprocedure

;SUBROUTINE GOES HERE

subr1   endp                ;end subprocedure
;---------------------------------------------
prognam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly