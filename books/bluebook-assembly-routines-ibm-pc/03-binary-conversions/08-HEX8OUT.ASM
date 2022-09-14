; Conversion from 8-Bit Binary to ASCII Hexadecimal

; Function:
; This routine accepts an 8-bit binary number in the DL.
; register and converts it to ASCII hexadecimal form which is sent to the
; standard output device.

; Input: 
; Upon entry an 8-bit binary number is in the DL register.

; Output: 
; A string of ASCII digits representing a hexadecimal number is
; sent out through the standard output device.

; Registers used: 
; No registers are modified. DL is used for input.

; Segments referenced: 
; None

; Routines called: 
; STDOUT

; Special notes:
; None



; ROUTINE TO CONVERT FROM INTERNAL 8-BIT BINARY TO ASCII HEXADECIMAL
;
hex8out proc    far
;
; a binary number is in DL
;
        push    cx              ; save registers
        push    ax
;
        mov     cx,2            ; loop for a count of 2
hex8out1:
        push    cx              ; save the count
        mov     cl,4            ; for a count of 4
        rol     dl,cl           ;  rotate DL left
;
        mov     al,dl           ; move into AL
        and     al,00Fh         ; just digit
        daa                     ; add 6 if A-F
        add     al,0F0h         ; bump a carry if A-F
        adc     al,040h         ; here is the ASCII
        call    stdout          ; send it out
;
        pop     cx
        loop    hex8out1
;
        pop     ax              ; restore registers
        pop     cx
        ret                     ; return
;
hex8out endp