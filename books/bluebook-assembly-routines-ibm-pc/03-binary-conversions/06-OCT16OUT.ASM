; Conversion from 16-bit Binary to ASCII Octal

; Function:
; This routine accepts a 16-bit binary number in the DX
; register and converts it to ASCII octal form which is sent to the standard
; output device.

; Input: 
; Upon entry a 16-bit binary number is in the DX register.

; Output:
; A string of ASCII digits representing an octal number is sent
; out through the standard output device.

; Registers used: 
; No registers are modified. DX is used for input.

; Segments referenced: 
; None

; Routines called: 
; STDOUT

; Special notes:
; None



; ROUTINE TO CONVERT FROM INTERNAL 16-BIT BINARY TO ASCII OCTAL
;
oct16out        proc    far
;
; a binary number is in DX
;
        push    cx              ; save registers
        push    ax
;
; first octal digit has only one bit
        rol     dx,1            ; rotate DX left once
;
        mov     al,dl           ; move into AL
        and     al,1            ; just keep digit
        add     al,30h          ; add 30h to AL
        call    stdout          ; send it out
;
; last five octal digits have 3 bits each
        mov     cx,5            ; loop for a count of 5
oct16out1:
        push    cx              ; save the count
        mov     cl,3            ; for a count of 3
        rol     dx,cl           ;  rotate DL left
;
        mov     al,dl           ; move into AL
        and     al,7            ; just keep digit
        add     al,30h          ; add 30h to AL
        call    stdout          ; send it out
        pop     cx              ; restore count
        loop    oct16out1
;
        pop     ax              ; restore registers
        pop     cx
        ret                     ; return
;
oct16out        endp