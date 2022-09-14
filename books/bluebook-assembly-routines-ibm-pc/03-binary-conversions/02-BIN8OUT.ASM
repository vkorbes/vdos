; Conversion from 8-Bit Binary to ASCII Binary

; Function:
; This routine accepts an 8-bit binary number in the DL
; register and converts it to ASCII binary form which is sent to the
; standard output device.

; Input: 
; Upon entry an 8-bit binary number is in the DL register.

; Output: 
; A string of ASCII digits representing a binary number is sent
; out through the standard output device.

; Registers used: 
; No registers are modified. DL is used for input.

; Segments referenced: 
; None

; Routines called: 
; STDOUT

; Special notes:
; None



; ROUTINE TO CONVERT FROM INTERNAL 8-BIT BINARY TO ASCII BINARY
;
bin8out proc    far
;
; a binary number is in DL
;
        push    cx              ; save registers
        push    ax
;
        mov     cx,8            ; loop for a count of 8
bin8out1:
        rol     dl,1            ; rotate DL left once
        mov     al,dl           ; move into AL
        and     al,1            ; just keep digit
        add     al,30h          ; add 30h to AL
        call    stdout          ; send it out
        loop    bin8out1
;
        pop     ax              ; restore registers
        pop     cx
        ret                     ; return
;
bin8out endp