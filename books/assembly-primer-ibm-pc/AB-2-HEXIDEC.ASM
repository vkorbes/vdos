;HEXIDEC--Main program
;  Converts hex on keyboard to dec on screen
;
hexidec segment
;---------------------------------------------
;
main    proc    far

        assume  cs:hexidec
;
;MAIN PART OF PROGRAM.  Links subroutines
;  together.
;
display equ     2h      ;video output
key_in  equ     1h      ;keyboard input
doscall equ     21h     ;DOS interrupt number
;
        push    ds          ;ds on stack
        sub     ax,ax       ;set ax=0
        push    ax          ;zero on stack
;
        call    hexibin     ;keyboard to binary
        call    crlf        ;print cr & linefeed
;
        call    binidec     ;binary to decimal
        call    crlf        ;print cr & linefeed
        jmp     main        ;get next input
;
main    endp
;---------------------------------------------
;
hexibin proc    near
;
;SUBROUTINE TO CONVERT HEX ON KEYBD TO BINARY
;  result is left in BX register
;
        mov     bx,0        ;clear BX for number
;
;get digit from keyboard, convert to binary
newchar:
        mov     ah,key_in   ;keyboard input
        int     doscall     ;call DOS
        sub     al,30h      ;ASCII to binary
        jl      exit        ;jump if < 0
        cmp     al,10d      ;is it > 9d ?
        jl      add_to      ;yes, so it's digit
;
;not digit (0 to 9), maybe letter (A to F)
        sub     al,27h      ;convert ASCII to bin
        cmp     al,0ah      ;is it < 0a hex?
        jl      exit        ;yes, not letter
        cmp     al,10h      ;is it > 0f hex?
        jge     exit        ;yes, not letter
;
;is hex digit.Add to number in BX
add_to:
        mov     cl,4        ;set shift count
        shl     bx,cl       ;rotate BX 4 bits
        mov     ah,0        ;zero out AH
        add     bx,ax       ;add digit to number
        jmp     newchar     ;get next digit
exit:
        ret
;
hexibin endp
;---------------------------------------------
;
binidec proc    near
;
;SUBROUTINE TO CONVERT BINARY NUMBER IN BX
;  TO DECIMAL ON CONSOLE SCREEN
;
        mov     cx,10000d   ;divide by 10000
        call    dec_div
        mov     cx,1000d    ;divide by 1000
        call    dec_div
        mov     cx,100d     ;divide by 100
        call    dec_div
        mov     cx,10d      ;divide by 10
        call    dec_div
        mov     cx,1d       ;divide by 1
        call    dec_div
        ret                 ;return from binidec
;
;- - - - - - - - - - - - - - - - - - - - - - -
;
dec_div proc    near
;
;sub-subroutine to divide number in BX by
;  number in CX, print quotient on screen
;  (numerator in AX+DX, denom in CX)
;
        mov     ax,bx       ;number high half
        mov     dx,0        ;zero out low half
        div     cx          ;divide by CX
        mov     bx,dx       ;remainder into BX
        mov     dl,al       ;quotient into DL
;
;print the contents of DL on screen
        add     dl,30h      ;convert to ASCII
        mov     ah,display  ;display function
        int     doscall     ;call DOS
        ret                 ;return from dev_div
;
dev_div endp
;- - - - - - - - - - - - - - - - - - - - - - -
;
binidec endp
;---------------------------------------------
;
crlf    proc    near
;
;prints carriage return and linefeed
;
        mov     dl,0ah      ;linefeed
        mov     ah,display  ;display function
        int     doscall     ;call DOS
;
        mov     dl,0dh      ;carriage return
        mov     ah,display  ;display function
        int     doscall     ;call DOS
        ret
;
crlf    endp
;---------------------------------------------
;
hexidec ends
        end     main
;
