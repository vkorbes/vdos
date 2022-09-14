; Conversion from ASCII Signed Decimal to Binary

; Function:
; This routine accepts a signed decimal number from the
; standard input device and converts it to internal signed two's complement
; 16-bit binary form.

; Input: 
; Individual digits of the signed decimal number are received in
; ASCII through a call to a standard input routine. The sign (‡) is
; optional and the valid digits are 0 through 9. An ASCII code other than
; that for the sign and the valid digits will terminate the routine.

; Output: 
; A signed two's complement 16-bit binary number is returned in
; the DX register.

; Registers used:
; AX and CX are modified. DX is used for output.

; Segments referenced: 
; None

; Routines called: 
; STDIN

; Special notes: 
; None



; ROUTINE TO CONVERT FROM ASCII SIGNED DECIMAL TO INTERNAL TWO'S
; COMPLEMENT 16-BIT BINARY
;
sgndec16in      proc    far
;
        mov     dx,0            ; initialize DX as 0
        mov     ch,0            ; sign flag
;
        call    stdin           ; look for sign
        cmp     al,'-'          ; minus
        jz      sgndec16in1     ; store it
        cmp     al,'+'          ; plus
        jz      sgndec16in2     ; ignore it
        jmp     sgndec16in3     ; anything else gets used
;
sgndec16in1:
; set sign as negative
        mov     ch,0FFh         ; 0FFh is -1
;
sgndec16in2:
; normal loop
        call    stdin           ; digit comes in AL
;
sgndec16in3:
; already have a digit?
        sub     al,30h          ; subtract 30h
        jl      sgndec16in4     ; check if too low
        cmp     al,9
        jg      sgndec16in      ; check if too high
        cbw                     ; convert to word
;
        push    cx              ; save sign
        push    ax              ; save digit
        mov     ax,dx
        mov     cx,10           ; multiplier of ten
        mul     cx              ; multiply
        mov     dx,ax           ; result in DX
        pop     ax              ; restore digit
;
        add     dx,ax           ; add in digit
        pop     cx              ; restore count
        jmp     sgndec16in2
;
sgndec16in4:
; resolve the sign
        cmp     ch,0            ; is it there?
        je      sgndec16in5     ; if not skip
;
        neg     dx              ; was a negative
;
sgndec16in5:
        ret                     ; return
;
sgndec16in      endp