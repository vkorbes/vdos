; DECIBIN--Program to get decimal digits
;          from keyboard and convert them
;          to binary number in BX

prognam segment

        assume cs:prognam

        mov     bx,0    ; clear BX for number

; Get digit from keyboard, convert to binary
newchar:
        mov  ah,1       ; keyboard input
        int  21h        ; call DOS
        sub  al,30h     ; ASCII to binary
        jl   exit       ; jump if < 0
        cmp  al,9d      ; is it > 9d ?
        jg   exit       ; yes, not dec digit
        cbw  ; byte in AL to word in AX
; (digit is now in A)
; Multiply number in BX by 10 decimal
        xchg ax,bx      ; trade digit & number
        mov  cx,10d     ; put 10 dec in CX
        mul  cx         ; number times 10
        xchg ax,bx      ; trade number & digit

; Add digit in AX to number in BX
        add  bx,ax      ; add digit to number
        jmp  newchar    ; get next digit

exit:
        int 20h

prognam ends

        end