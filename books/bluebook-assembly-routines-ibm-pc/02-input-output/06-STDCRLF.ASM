; Standard Output of Carriage Return/Linefeed

; Function:
; This routine sends a carriage return and then a linefeed out
; through the standard output device.

; Input:
; None

; Output:
; ASCII codes 13 for carriage return and the ASCII code 10 for
; linefeed are sent to the standard output device.

; Registers Used: 
; No registers are modified.

; Segments Referenced:
; None

; Routines Called: 
; STDOUT

; Special Notes:
; None



; ROUTINE TO SEND CR LF TO STANDARD OUTPUT
;
stdcrlf proc    far
        push    ax              ; save registers
;
        mov     al,13           ; ASCII carriage return
        call    stdout          ; send it out
        mov     al,10           ; ASCII linefeed
        call    stdout          ; send it out
;
        pop     ax              ; restore registers
        ret                     ; return
stdcrlf endp