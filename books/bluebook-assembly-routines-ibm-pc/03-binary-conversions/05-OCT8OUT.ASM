; Conversion from 8-Bit Binary to ASCII Octal

; Function:
; This routine accepts an 8-bit binary number in the DL
; register and converts it to ASCII octal form which is sent to the standard
; output device.

; Input:
; Upon entry an 8-bit binary number is in the DL register.

; Output: 
; A string of ASCII digits representing an octal number is sent
; out through the standard output device.

; Registers used: 
; No registers are modified. DL is used for input.

; Segments referenced:
; None

; Routines called: 
; STDOUT

; Special notes: 
; None



; ROUTINE TO CONVERT FROM INTERNAL 8-BIT BINARY TO ASCII OCTAL
;
oct8out proc    far
;
; a binary number is in DL
;
        push    cx              ; save registers
        push    ax
;
; first octal digit has only 2 bits
        mov     cl,2            ; for a count of 2
        rol     dl,cl           ;  rotate DL left
;
        mov     al,dl           ; move into AL
        and     al,3            ; just keep digit
        add     al,30h          ; add 30h to AL
        call    stdout          ; send it out
;
; second and third octal digits have 3 bits each
        mov     cx,2            ; loop for a count of 2
oct8out1:
        push    cx              ; save the count
        mov     cl,3            ; for a count of 3
        rol     dl,cl           ;  rotate DL left
;
        mov     al,dl           ; move into AL
        and     al,7            ; just keep digit
        add     al,30h          ; add 30h to AL
        call    stdout          ; send it out
        pop     cx              ; restore count
        loop    oct8out1
;
        pop     ax              ; restore registers
        pop     cx
        ret                     ; return
;
oct8out endp