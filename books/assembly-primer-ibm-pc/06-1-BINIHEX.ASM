prognam segment         ; start of segment

        assume cs:prognam

        mov  ch,4       ; number of digits
rotate: mov  cl,4       ; set count to 4 bits
        rol  bx,cl      ; left digit to right
        mov  al,bl      ; move to AL
        and  al,0fh     ; mask off left digit
        add  al,30h     ; convert hex to ASCII
        cmp  al,3ah     ; is it > 9?
        jl   printit    ; jump if digit =0 or 9
        add  al,7h      ; digit is A to F
printit:
        mov  dl,al      ; put ASCII char in DL
        mov  ah,2       ; Display Output funct
        int  21h        ; call DOS
        dec  ch         ; done 4 digits?
        jnz  rotate     ; not yet

        int  20h        ; return to DEBUG

prognam ends

        end