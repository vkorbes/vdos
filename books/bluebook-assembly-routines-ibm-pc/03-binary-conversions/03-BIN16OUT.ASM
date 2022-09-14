; Conversion from 16-Bit Binary to ASCII Binary

; Function: 
; This routine accepts a 16-bit binary number in the DX
; register and converts it to ASCII binary form which is sent to the
; standard output device.

; Input: 
; Upon entry a 16-bit binary number is in the DX register.

; Output: 
; A string of ASCII digits representing a binary number is sent
; out through the standard output device.

; Registers used: 
; No registers are modified. DX is used for input.

; Segments referenced: 
; None

; Routines called: 
; STDOUT

; Special notes: 
; None



; ROUTINE TO CONVERT FROM INTERNAL 16-BIT BINARY TO ASCII BINARY
;
bin16out        proc    far
;
; a binary number is in DX
;
        push    cx              ; save registers
        push    ax
;
        mov     cx,16           ; loop for a count of 16
bin16out1:
        rol     dx,1            ; rotate DX left once
        mov     al,dl           ; move into AL
        and     al,1            ; just keep digit
        add     al,30h          ; add 30h to AL
        call    stdout          ; send it out
        loop    bin16out1
;
        pop     ax              ; restore registers
        pop     cx
        ret                     ; return
;
bin16out        endp