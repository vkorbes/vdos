;SHIFT STATUS TEST PROGRAM--
;  Display shift status continously

sh_stat equ     2h      ;shift status function
key_rom equ     16h     ;keyboard ROM call

display equ     2h      ;DOS display routine
doscall equ     21h     ;DOS interrupt number

return  equ     0dh     ;carriage return

;*********************************************
prognam segment         ;define code segment

;---------------------------------------------
main    proc    far     ;main part of program

        assume  cs:prognam

again:  mov     ah,sh_stat  ;sh status function
        int     key_rom     ;call kbd ROM routine
        mov     bx,ax       ;put result in BX
        call    binihex     ;print out result
        mov     dl,return   ;print carriage return
        mov     ah,display
        int     doscall
        jmp     again       ;repeat

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
prognam ends    ;end of code segment
;*********************************************

        end     ;end assembly