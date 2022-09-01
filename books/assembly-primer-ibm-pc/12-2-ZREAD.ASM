;ZREAD--Program to read file
;          uses ASCIIZ format
;
;*********************************************

datarea segment         ;define data segment

nambuff db  49          ;maximum bytes
        db  ?           ;bytes actually read
        db  50 dup (?)  ;buffer
datbuff db  200 dup (?) ;data buffer
intro   db  0dh,0ah,'Enter Pathname: $'
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

;SET DS TO DATA BUFFER
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

;INSERT ZERO IN BUFFER FOLLOWING NAME
        mov     bl,nambuff+1     ;get # of bytes read
        mov     bh,0             ;put in BX
        mov     [nambuff+bx+2],0 ;zero into byte

;OPEN FILE
        mov     dx,offset nambuff+2 ;addr of name
        mov     al,0        ;file open for reading
        mov     ah,3dh      ;funct # to open file
        int     21h         ;call DOS
        mov     bx,ax       ;handle/error in BX
        jc      error       ;error return?

;READ FILE
newbuff:
        mov     cx,200      ;# of bytes to read
        mov     dx,offset datbuff ;addr of buffer
        mov     ah,3fh      ;read from file functn
        int     21h         ;call DOS
        jc      error       ;error return?
        cmp     ax,0        ;no, are we at EOF ?
        je      exit        ;yes, exit

;DISPLAY BUFFER CONTENTS
        mov     si,bx       ;save handle
        mov     cx,ax       ;# of chars read in CX
        mov     bx,offset datbuff ;addr of buffer
newchar:
        mov     ah,2        ;display output funct
        mov     dl,[bx]     ;get character
        cmp     dl,1ah      ;is it end-of-file ?
        je      exit        ;yes, exit
        int     21h         ;call DOS, display it
        inc     bx          ;point to next char
        loop    newchar     ;done all chars?
        mov     bx,si       ;yes, restore handle
        jmp     newbuff     ;go fill buffer again
exit:
        ret                 ;return to DOS

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
zread   ends    ;end of code segment
;*********************************************
        end     ;end assembly