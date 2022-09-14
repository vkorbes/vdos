; Conversion from 16-Bit binary to ASCII Hexadecimal

; Function: 
; This routine accepts a 16-bit binary number in the DX
; register and converts it to ASCII hexadecimal form which is sent to the
; standard output device.

; Input: 
; Upon entry a 16-bit binary number is in the DX register.

; Output:
; A string of ASCII digits representing a hexadecimal number is
; sent out through the standard output device.

; Registers used: 
; No registers are modified. DX is used for input.

; Segments referenced: 
; None

; Routines called: 
; STDOUT

; Special notes: 
; None



; ROUTINE TO CONVERT FROM INTERNAL 16-BIT BINARY TO ASCII HEXADECIMAL
;
hex16out        proc    far
;
; a binary number is in DX
;
        push    cx              ; save registers
        push    ax
;
        mov     cx,4            ; loop for a count of 4
hex16out1:
        push    cx              ; save the count
        mov     cl,4            ; for a count of 4
        rol     dx,cl           ;  rotate DX left
;
        mov     al,dl           ; move into AL
        and     al,00Fh         ; just the digit
        daa                     ; add 6 if A-F
        add     al,0F0h         ; bump a carry if A-F
        adc     al,040h         ; here is the ASCII
        call    stdout          ; send it out
;
        pop     cx
        loop    hex16out1
;
        pop     ax              ; restore registers
        pop     cx
        ret                     ; return
;
hex16out        endp