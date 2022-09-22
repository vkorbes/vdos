; Turn on Tone

; Function:
; Turns on the timer and speaker to produce a tone. The
; frequency of the tone must have already been selected on the timer. You
; can use TONESET to set the frequency of the tone.

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



; ROUTINE TO TURN ON TONE
;
toneon  proc    far
;
        push    ax              ; save registers
;
; turn speaker and timer on
        in      al,61h          ; get contents of system port B
        or      al,3            ; turn speaker and timer on
        out     61h,al          ; send out new values to port B
;
        pop     ax              ; restore registers
        ret
;
toneon  endp