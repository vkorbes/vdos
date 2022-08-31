; DECIHEX--Main Program
;   Converts decimal on keybd to hex on screen
; *********************************************

decihex segment
        assume cs:decihex

; MAIN PART OF PROGRAM.  Connects procedures
;   together.

repeat: call    decibin ;keyboard to binary
        call    crlf    ;print cr and lf

        call    binihex ;binary to screen
        call    crlf    ;print cr and lf

        jmp     repeat  ;do it again

;---------------------------------------------
;PROCEDURE TO CONVERT DEC ON KEYBD TO BINARY
;  Result is left in BX register

decibin proc    near

        mov     bx,0    ;clear BX for number

;Get digit from keyboard, converto to binary
newchar:
        mov     ah,1    ;keyboard input
        int     21h     ;call DOS
        sub     al,30h  ;ASCII to binary
        jl      exit    ;jump if < 0
        cmp     al,9d   ;is it > 9d ?
        jg      exit    ;yes, not dec digit
        cbw     ;byte in AL to word in AX
;(digit is now in AX)

;Multiply number in bx by 10 decimal
        xchg    ax,bx   ;trade digit & number
        mov     cx,10d  ;put 10 dec in CX
        mul     cx      ;number times 10
        xchg    ax,bx   ;trade number & digit

;Add digit in ax to number in bx
        add     bx,ax   ;add digit to number
        jmp     newchar ;get next digit
exit:
        ret             ;return from decibin

decibin endp

;---------------------------------------------
;PROCEDURE TO CONVERT BINARY NUMBER IN BX
;  TO HEX ON CONSOLE SCREEN

binihex proc    near

        mov     ch,4    ;number of digits
rotate: mov     cl,4    ;set count to 4 bits
        rol     bx,cl   ;left digit to right
        mov     al,bl   ;move to AL
        and     al,0fh  ;mask off left digit
        add     al,30h  ;convert hex to ASCII
        cmp     al,3ah  ;is it > 9 ?
        jl      printit ;jump if digit = 0 to 9
        add     al,7h   ;digit is A to F
printit:
        mov     dl,al   ;put ASCII char in DL
        mov     ah,2    ;Display Output funct
        int     21h     ;call DOS
        dec     ch      ;done 4 digits?
        jnz     rotate  ;not yet

        ret             ;return from binihex

binihex endp

;---------------------------------------------
;PROCEDURE TO PRINT CARRIAGE RETURN
;        AND LINEFEED

crlf    proc    near

        mov     dl,0dh  ;carriage return
        mov     ah,2    ;display function
        int     21h     ;call DOS

        mov     dl,0ah  ;linefeed
        mov     ah,2    ;display function
        int     21h     ;call DOS

        ret             ;return from crlf

crlf    endp

;---------------------------------------------
decihex ends
;*********************************************

        end