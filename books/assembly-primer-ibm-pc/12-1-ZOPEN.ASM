;ZOPEN--Program to open file
;          uses ASCIIZ format
;          prints file "handle" if found
;
;*********************************************

datarea segment         ;define data segment

nambuff db  49          ;maximum bytes
        db  ?           ;bytes actually read
        db  50 dup (?)  ;buffer
intro   db  0dh,0ah,'Enter Pathname: $'
emess   db  'Error $'
crlf    db  0dh,0ah,'$' ;return and linefeed
datarea ends

;*********************************************

zopen    segment         ;define code segment

;---------------------------------------------

main    proc    far     ;main part of program

        assume  cs:zopen,ds:datarea

start:          ;starting execution address

;SET STACK UP FOR RETURN
        push    ds          ;save old data segment
        sub     ax,ax       ;put zero in AX
        push    ax          ;save it on stack

;SET DS TO DATA BUFFER
        mov     ax,datarea
        mov     ds,ax

;READ IN PATHNAME OF FILE TO BE OPENED
newfile:
        mov     dx,offset intro ;intro message
        mov     ah,9h       ;print message funct
        int     21h         ;call DOS

        mov     dx,offset crlf  ;return + linefeed
        mov     ah,9h       ;print message functn
        int     21h         ;call DOS

;INSERT ZERO IN BUFFER FOLLOWING NAME
        mov     bl,nambuff+1     ;get # of bytes read
        mov     bh,0             ;put in BX
        mov     [nambuff+bx+2],0 ;zero into byte

;SET DS:DX TO ASCIIZ STRING
        mov     dx,offset nambuff+2 ;addr of name

;SET AL TO ACCESS CODE
        mov     al,0        ;file open for reading

;OPEN THE FILE
        mov     ah,3dh      ;funct # to open file
        int     21h         ;call DOS

        mov     bx,ax       ;put "handle" in BX
        jc      error       ;error return?
        call    binihex     ;no, print handle
        jmp     newfile     ;get another file

;ERROR ROUTINE 
error:
        mov     dx,offset emess ;error message
        mov     ah,9h       ;funct # to print mess
        int     21h         ;call DOS
        call    binihex     ;print error number
        ret                 ;return to DOS

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
zopen   ends    ;end of code segment
;*********************************************
        end     ;end assembly