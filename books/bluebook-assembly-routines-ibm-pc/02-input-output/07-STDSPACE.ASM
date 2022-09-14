; Standard Output of Space

; Function:
; This routine sends a space out through the standard output
; device.

; Input:
; None

; Output:
; ASCII code 32 for space is sent to the standard output device.
; Registers Used: No registers are modified.

; Segments Referenced:
; None

; Routines Called: 
; STDOUT

; Special Notes:
; None



; ROUTINE TO SEND SPACE TO STANDARD OUTPUT
;
; A space is sent to the standard output device
;
stdspace        proc    far
        push    ax              ; save registers
;
        mov     al,32           ; ASCII space
        call    stdout          ; send it out
;
        pop     ax              ; restore registers
        ret                     ; return
stdspace        endp