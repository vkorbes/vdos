;KEYBOARD I/O TEST--Prints out
;scan code and ASCII of any key

display equ     2h      ;display character fnc
doscall equ     21h     ;DOS interrupt routine

;*********************************************

pro_nam segment         ;define code segment

;---------------------------------------------
main    proc    far     ;main part of program

        assume  cs:pro_nam

again:  mov     ah,0        ;read character funct
        int     16h         ;keyboard I/O ROM call
        mov     bx,ax       ;move AX to BX
        call    binihex     ;print scancode & char
        mov     dl,20h      ;print space
        mov     ah,display
        int     doscall
        mov     dl,bl       ;print character
        mov     ah,display  ;   in ASCII
        int     doscall
        mov     dl,0ah      ;print return
        mov     ah,display
        int     doscall
        mov     dl,0ah      ;print linefeed
        mov     ah,display
        int     doscall

        jmp     again       ;get another one

        int     20h ;return from program to DOS

main    endp    ;end of main part of program
;---------------------------------------------
binihex proc    near

;SUBROUTINE TO CONVERT BINARY NUMBER IN BX
;  TO HEX ON CONSOLE SCREEN

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
        mov  ah,display ;display output funct.
        int  doscall    ;call DOS
        dec  ch         ;done 4 digits?
        jnz  rotate     ;not yet
        ret             ;done subroutine

binihex endp
;---------------------------------------------
pro_nam ends    ;end of code segment
;*********************************************

        end     ;end assembly