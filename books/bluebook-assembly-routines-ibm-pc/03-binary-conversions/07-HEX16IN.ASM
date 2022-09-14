; Conversion from ASCII Hexadecimal to 16-Bit Binary

; Function:
; This routine accepts a hexadecimal number from the standard
; input device and converts it to internal 16-bit binary form.

; Input: 
; The individual digits of the hexadecimal number are received in
; ASCII through a call to a standard I/O routine. The valid digits are 0
; through 9 and A through F. An ASCII code other than for a valid digit
; will terminate the routine.

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



; ROUTINE TO CONVERT FROM ASCII HEXADEMICAL TO INTERNAL 16-BIT BINARY
;
hex16in proc    far
;
        push    cx              ; save registers
        push    ax
;
        mov     dx,0            ; initialize DX as 0
;
hex16in1:
        call    stdin           ; a digit comes in AL
        sub     al,30h          ; subtract 30h
        jl      hex16in3        ; check if too low
        cmp     al,9
        jle     hex16in2        ; go if ok
        and     al,5Fh          ; for lower case too
        sub     al,7            ; adjust for A-F
        jl      hex16in3        ; too low for A-F
        cmp     al,15           ; check if too high
        jg      hex16in3
;
hex16in2:
        cbw
        mov     cl,4            ; for a count of 4
        sal     dx,cl           ;  shift DX left
        add     dx,ax           ; add in digit
        jmp     hex16in1
;
hex16in:
        pop     ax              ; restore registers
        pop     cx
        ret                     ; return
;
hex16in endp