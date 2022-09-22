; Initialize Speaker Timer

; Function:
; This routine initializes the portion of the 8253 timer chip
; used by the speaker system. In particular, it sets up channel 2 of this
; timer as a square wave generator. This routine does not select the
; frequency nor turn on the tone. Use TONESET to select the frequency,
; TONEON to turn the tone on, and TONEOFF to turn it off.

; Input:
; None

; Output:
; Only to the timer 2 of the speaker circuit.

; Registers Used: 
; No registers are modified.

; Segments Referenced:
; None

; Routines Called: None

; Special Notes:
; None



: ROUTINE TO SET TONE
;
; define control bit field parameters for the timer chip
sc      =       2               ; use counter 2
rl      =       3               ; mode to load period one byte at a time
mode    =       3               ; square wave generator
bcd     =       0               ; not bcd, use binary values
;
; form control word
cnword  =       sc*40h + rl*10h + mode*2 + bcd
;
toneinit        proc    far
;
        push    ax              ; save registers
; send control word to 8523 timer chip
        mov     al,cnword       ; select the above control word
        out     43h,al          ; send it out the control port
;
        pop     ax              ; restore registers
        ret
;
toneinit        endp