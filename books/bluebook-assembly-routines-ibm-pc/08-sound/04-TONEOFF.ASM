; Turn off Tone

; Function:
; This routine turns off the timer and speaker.

; Input:
; None

; Output:
; To the timer and speaker only.

; Registers Used:
; No registers are modified.

; Segments Referenced: 
; None

; Routines Called:
; None

; Special Notes:
; None



; ROUTINE TO TURN TONE OFF
;
toneoff proc    far
;
        push    ax              ; save registers
;
; turn off time 2 and speaker
        in      al,61h          ; get port B again
        and     al,11111100b    ; turn off timer and speaker
        out     61h,al          ; now do it
;
        pop     ax              ; restore registers
        ret
;
toneoff endp