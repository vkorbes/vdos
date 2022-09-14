; Conversion from ASCII Decimal to 16-Bit Binary

; Function:
; This routine accepts a decimal number from the standard
; input device and converts it to internal 16-bit binary form.

; Input:
; The individual digits of the decimal number are received in
; ASCII through a call to a standard I/O routine. The valid digits are 0
; through 9. An ASCII code other than for a valid digit will terminate the
; routine.

; Output:
; A 16-bit binary number is returned in the DX register.

; Registers used: 
; Only DX is modified. It returns the result.

; Segments referenced: 
; None

; Routines called: 
; STDIN

; Special notes:
; None



; ROUTINE TO CONVERT FROM ASCII DECIMAL TO INTERNAL 16-BIT BINARY
;
dec16in proc    far
;
        push    cx              ; save registers
        push    ax
;
        mov     dx,0            ; initialize DX as 0
;
dec16in1:
        call    stdin           ; digit comes in AL
        sub     al,30h          ; subtract 30h
        jl      dec16in2        ; check if too low
        cmp     al,9
        jg      dec16in2        ; check if too high
        cbw                     ; convert to word
;
        push    ax              ; save digit
        mov     ax,dx
        mov     cx,10           ; multiplier of 10
        mul     cx              ; multiply
        mov     dx,ax           ; result in DX
        pop     ax              ; restore digit
        add     dx,ax           ; add in digit
        jmp     dec16in1
;
dec16in2:
        pop     ax              ; restore registers
        pop     cx
        ret                     ; return
;
dec16in endp