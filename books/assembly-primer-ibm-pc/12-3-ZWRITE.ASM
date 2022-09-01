;ZWRITE--Program to write file
;          from keyboard input
;        Uses ASCIIZ format
;
;*********************************************

datarea segment         ;define data segment

nambuff db  50          ;max pathname bytes
        db  ?           ;bytes actually read
        db  50 dup (?)  ;buffer

datbuff db  80          ;maximum text bytes
        db  ?           ;bytes actually typed
        db  80 dup (?)  ;text buffer

handle  dw  ?           ;handle storage
intro   db  0dh,0ah,'Enter Pathname: $'
intro2  db  0dh,0ah,'Enter Text:',0dh,0ah,'$'
emess   db  'Error $'

crlf    db  0dh,0ah,'$' ;return and linefeed
datarea ends
;*********************************************

zread    segment         ;define code segment

;---------------------------------------------

main    proc    far     ;main part of program

        assume  cs:zread,ds:datarea

;set up stack for return
start:
        push    ds          ;save old data segment
        sub     ax,ax       ;put zero in AX
        push    ax          ;save it on stack

;set DS to data segment
        mov     ax,datarea
        mov     ds,ax

;READ IN PATHNAME OF FILE TO BE OPENED
newfile:
        mov     dx,offset intro ;intro message
        mov     ah,9h       ;print message funct
        int     21h         ;call DOS

        mov     dx,offset nambuff ;addr of buffer
        mov     ah,0ah      ;print message funct
        int     21h         ;call DOS

        mov     dx,offset crlf  ;return + linefeed
        mov     ah,9h       ;print message functn
        int     21h         ;call DOS

;CREATE FILE
        mov     dx,offset nambuff+2 ;addr of name
        mov     cx,0        ;normal attribute
        mov     ah,3ch      ;create file function
        int     21h         ;call DOS
        mov     handle,ax   ;store handle
        jc      error       ;error return?

;GET TEXT FROM KEYBOARD
        mov     dx,offset intro2 ;intro message
        mov     ah,9h       ;print message funct
        int     21h         ;call DOS
newline:
        mov     dx,offset datbuff   ;addr of buffer
        mov     ah,0ah      ;buff kbd input funct
        int     21h         ;call DOS
        cmp     datbuff+1,1 ;if no chars typed
        jle     exit        ;then exit

;insert return and linefeed after typed chars
        mov     bl,datbuff+1    ;put character count
        mov     bh,0        ;in BX, then insert
        mov     [datbuff+bx+2], 0dh ;return in buf
        mov     [datbuff+bx+3], 0ah ;linefd in buf
        add     datbuff+1,2     ;add 2 to count

        mov     dx,offset crlf ;return + linefeed
        mov     ah,9h       ;print message functn
        int     21h         ;call DOS

;WRITE FILE TO DISK
        mov     bx,handle   ;get handle back in BX
        mov     dx,offset datbuff+2 ;addr of buff
        mov     cl,datbuff+1    ;# of bytes to write
        mov     ch,0            ;into CX
        mov     ah,40h      ;write filefunction
        int     21h         ;call DOS
        jc      error       ;error return?
        cmp     al,datbuff+1    ;# of bytes written
        jne     error       ;same as requested?
        jmp     newline     ;go read another line

;CLOSE FILE AND EXIT
exit:
        mov     dx,offset emess ;error message
        mov     ah,9h       ;funct # to print mess
        int     21h         ;call DOS
        mov     bx,handle   ;handle is error #
        call    binihex     ;print error number
        jmp     exit

main    endp    ;end of main part of program
;---------------------------------------------
;
binihex proc    near
;
;SUBROUTINE TO CONVERT BINARY NUMBER IN BX
;  TO HEX ON CONSOLE SCREEN
;
        mov  ch,4       ;number of digits
rotate: mov  cl,4       ;set count to 4 bits
        rol  bx,cl      ;left digit to right
        mov  al,bl      ;move to AL (DL???)
        and  al,0fh     ;mask off left digit
        add  al,30h     ;convert hex to ASCII
        cmp  al,3ah     ;is it > 9?
        jl   printit    ;no, so 0 to 9 digit
        add  al,7h      ;yes, so A to F digit
printit:
        mov  dl,al      ;put ASCII char in DL
        mov  ah,2       ;display output funct.
        int  21h        ;call DOS
        dec  ch         ;done 4 digits?
        jnz  rotate     ;not yet
        ret             ;done subroutine
;
binihex endp
;---------------------------------------------
zread   ends    ;end of code segment
;*********************************************
        end     ;end assembly